defmodule FoodOrderWeb.Admin.Product.FormComponentTest do
  use FoodOrderWeb.ConnCase

  import Phoenix.LiveViewTest
  import FoodOrder.Factory

  alias FoodOrder.Products.Repositories.ProductsRepository
  alias FoodOrderWeb.Admin.Product.FormComponent

  describe "mount/3" do
    test "should load modal to insert a product", %{conn: conn} do
      changeset = ProductsRepository.change_product()

      {:ok, view, _html} = live(conn, Routes.admin_product_path(conn, :index))

      assert has_element?(view, "#new-product")

      assert render_component(FormComponent, id: "new-product", changeset: changeset) =~
               "<form action=\"#\" method=\"post\" id=\"new-product\""

      assert view
             |> form("#new-product", product: %{name: "Product #1"})
             |> render_change() =~ "can&#39;t be blank"
    end
  end

  describe "handle_event on save" do
    test "given a product when submit the form then return a message that created the product", %{
      conn: conn
    } do
      changeset = params_for(:product)
      {:ok, view, _html} = live(conn, Routes.admin_product_path(conn, :index))

      {:ok, _view, html} =
        view
        |> form("#new-product", product: changeset)
        |> render_submit()
        |> follow_redirect(conn, Routes.admin_product_path(conn, :index))

      assert html =~ "Product has created"
    end

    test "given an invalid product when submit the form then return a changeset error", %{
      conn: conn
    } do
      {:ok, view, _html} = live(conn, Routes.admin_product_path(conn, :index))
      changeset = params_for(:invalid_product)

      assert view
             |> form("#new-product", product: changeset)
             |> render_submit() =~
               "<span class=\"invalid-feedback\" phx-feedback-for=\"product[name]\">can&#39;t be blank</span>"
    end
  end
end
