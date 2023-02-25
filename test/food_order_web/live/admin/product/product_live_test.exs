defmodule FoodOrderWeb.Admin.ProductLiveTest do
  use FoodOrderWeb.ConnCase

  import Phoenix.LiveViewTest
  import FoodOrder.Factory

  setup :register_and_log_in_user

  test "should has an table#all-foods and a tbody#foods-list", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.admin_product_path(conn, :index))

    assert has_element?(view, "table#all-foods")
    assert has_element?(view, "tbody#foods-list")
  end

  test "should has an thead>tr>th with product-name, product-price, product-size, product-actions data-ids",
       %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.admin_product_path(conn, :index))

    assert has_element?(view, "thead>tr>th[data-id=head-name]", "Name")
    assert has_element?(view, "thead>tr>th[data-id=head-price]", "Price")
    assert has_element?(view, "thead>tr>th[data-id=head-size]", "Size")
    assert has_element?(view, "thead>tr>th[data-id=head-actions]", "Actions")
  end

  test "should has an tbody with id equals product id", %{conn: conn} do
    product = insert(:product)

    {:ok, view, _html} = live(conn, Routes.admin_product_path(conn, :index))

    assert has_element?(view, "tbody>tr##{product.id}product")

    assert has_element?(
             view,
             "tbody>tr##{product.id}product>td[data-role=product-name][data-id=#{product.id}]",
             product.name
           )

    assert has_element?(
             view,
             "tbody>tr##{product.id}product>td[data-role=product-price][data-id=#{product.id}]",
             Money.to_string(product.price, symbol: true)
           )

    assert has_element?(
             view,
             "tbody>tr##{product.id}product>td[data-role=product-size][data-id=#{product.id}]",
             product.size
           )
  end

  test "given a product already exists when click to delete, remove from database and update page",
       %{conn: conn} do
    product = insert(:product)

    {:ok, view, _html} = live(conn, Routes.admin_product_path(conn, :index))

    assert view
           |> element("[data-role=delete][data-id=#{product.id}]", "Delete")
           |> render_click()

    refute has_element?(view, "[data-role=delete][data-id=#{product.id}]", "Delete")
  end
end
