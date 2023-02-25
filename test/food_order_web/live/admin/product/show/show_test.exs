defmodule FoodOrderWeb.Admin.ProductLive.ShowTest do
  use FoodOrderWeb.ConnCase

  import Phoenix.LiveViewTest
  import FoodOrder.Factory

  setup :register_and_log_in_admin

  describe "mount/3" do
    test "should load modal to insert a product", %{conn: conn} do
      product = insert(:product)

      {:ok, view, _html} = live(conn, Routes.admin_product_show_path(conn, :show, product.id))

      assert has_element?(view, "[data-role=name]", product.name)
      assert has_element?(view, "[data-role=description]", product.description)
      assert has_element?(view, "[data-role=price]", Money.to_string(product.price))
      assert has_element?(view, "[data-role=size]", product.size)
    end
  end
end
