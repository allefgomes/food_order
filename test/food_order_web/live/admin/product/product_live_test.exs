defmodule FoodOrderWeb.Admin.ProductLiveTest do
  use FoodOrderWeb.ConnCase

  import Phoenix.LiveViewTest
  import FoodOrder.Factory

  describe "mount/3" do
    test "should has an table#all-foods and a tbody#foods-list", %{conn: conn} do
      {:ok, view, _html} = live(conn, Routes.admin_product_path(conn, :index))

      assert has_element?(view, "table#all-foods")
      assert has_element?(view, "tbody#foods-list")
    end

    test "should has an thead>tr>th with product-name, product-price, product-size, product-actions data-ids", %{conn: conn} do
      {:ok, view, _html} = live(conn, Routes.admin_product_path(conn, :index))

      assert has_element?(view, "thead>tr>th[data-id=head-name]", "Name")
      assert has_element?(view, "thead>tr>th[data-id=head-price]", "Price")
      assert has_element?(view, "thead>tr>th[data-id=head-size]", "Size")
      assert has_element?(view, "thead>tr>th[data-id=head-actions]", "Actions")
    end

    test "should has an tbody with id equals product id", %{conn: conn} do
      product = insert(:product)

      {:ok, view, _html} = live(conn, Routes.admin_product_path(conn, :index))

      assert has_element?(view, "tbody>tr##{product.id}")
      assert has_element?(view, "tbody>tr##{product.id}>td[data-role=product-name][data-id=#{product.id}]", product.name)
      assert has_element?(view, "tbody>tr##{product.id}>td[data-role=product-price][data-id=#{product.id}]", Integer.to_string(product.price))
      assert has_element?(view, "tbody>tr##{product.id}>td[data-role=product-size][data-id=#{product.id}]", product.size)
      assert has_element?(view, "tbody>tr##{product.id}>td[data-role=product-actions][data-id=#{product.id}]", "Show | Edit | Delete")
    end
  end
end
