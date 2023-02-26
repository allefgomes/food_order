defmodule FoodOrderWeb.Admin.Product.FormComponentTest do
  use FoodOrderWeb.ConnCase

  import Phoenix.LiveViewTest
  import FoodOrder.Factory

  setup :register_and_log_in_admin

  describe "mount/3" do
    test "should load modal to insert a product", %{conn: conn} do
      product = insert(:product)

      {:ok, view, _html} = live(conn, Routes.admin_product_path(conn, :index))

      assert view |> element("[data-role=edit-product][data-id=#{product.id}]") |> render_click()
      assert_patch(view, Routes.admin_product_path(conn, :edit, product))

      assert view
             |> form("##{product.id}", product: %{name: nil})
             |> render_submit() =~ "can&#39;t be blank"
    end
  end

  describe "handle_event on save" do
    test "given a product when submit the form then return a message that created the product", %{
      conn: conn
    } do
      changeset = params_for(:product)
      {:ok, view, _html} = live(conn, Routes.admin_product_path(conn, :index))
      open_modal(view)

      {:ok, _view, html} =
        view
        |> form("#new", product: changeset)
        |> render_submit()
        |> follow_redirect(conn, Routes.admin_product_path(conn, :index))

      assert html =~ "Product has created"
    end

    test "given an invalid product when submit the form then return a changeset error", %{
      conn: conn
    } do
      {:ok, view, _html} = live(conn, Routes.admin_product_path(conn, :index))
      open_modal(view)
      changeset = params_for(:invalid_product)

      assert view
             |> form("#new", product: changeset)
             |> render_submit() =~
               "<span class=\"invalid-feedback\" phx-feedback-for=\"product[name]\">can&#39;t be blank</span>"
    end
  end

  test "create product with iamge",
         %{conn: conn} do
      {:ok, view, _html} = live(conn, Routes.admin_product_path(conn, :index))

      open_modal(view)

      upload =
        file_input(view, "#new", :photo, [
          %{
            last_modified: 1_594_171_879_000,
            name: "myfile.jpeg",
            content: "    ",
            type: "image/jpeg"
          }
        ])

      assert render_upload(upload, "myfile.jpeg", 100) =~ "100%"

      payload = %{name: "pumpking", description: "abc 123", price: 123, size: "small"}

      {:ok, _, html} =
        view
        |> form("#new", product: payload)
        |> render_submit()
        |> follow_redirect(conn, Routes.admin_product_path(conn, :index))

      assert html =~ "Product has created"
      assert html =~ "pumpking"
    end

  test "should cancel upload", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.admin_product_path(conn, :new))

    upload =
      file_input(view, "#new", :photo, [
        %{
          last_modified: 1_594_171_879_000,
          name: "myfile.jpeg",
          content: "    ",
          type: "image/jpeg"
        }
      ])

    assert render_upload(upload, "myfile.jpeg", 100) =~ "100%"

    assert has_element?(
             view,
             "[data-role=image-loaded][data-id=#{hd(upload.entries)["ref"]}]",
             "100"
           )

    ref = "[data-role=cancel][data-id=#{hd(upload.entries)["ref"]}]"
    assert has_element?(view, ref)
    assert element(view, ref) |> render_click()
    refute has_element?(view, ref)
  end

  test "given a product that already exists, edit", %{
    conn: conn
  } do
    product = insert(:product)
    {:ok, view, _html} = live(conn, Routes.admin_product_path(conn, :index))
    open_modal(view)

    assert view
           |> element("[data-role=edit-product][data-id=#{product.id}]")
           |> render_click()

    assert view
           |> has_element?("#modal")

    assert_patch(view, Routes.admin_product_path(conn, :edit, product))

    assert view
           |> form("##{product.id}", product: %{name: nil})
           |> render_change() =~ "can&#39;t be blank"

    {:ok, _view, html} =
      view
      |> form("##{product.id}", product: %{name: "abobora"})
      |> render_submit()
      |> follow_redirect(conn, Routes.admin_product_path(conn, :index))

    assert html =~ "Product updated!"
  end


  defp open_modal(view) do
    view
    |> element("[data-role=add-new-product]", "New")
    |> render_click()
  end
end
