defmodule FoodOrderWeb.Admin.Product.FormComponentTest do
  use FoodOrderWeb.ConnCase

  import Phoenix.LiveViewTest

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
end
