defmodule FoodOrderWeb.Main.Products.ProductTest do
  use FoodOrderWeb.ConnCase
  import Phoenix.LiveViewTest

  test "load page", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.main_path(conn, :index))

    assert has_element?(view, "h2", "Produto com nome")
    assert has_element?(view, "span.size", "Small")
    assert has_element?(view, "div > span.font-bold", "$ 10")
    assert has_element?(view, "div > button > span", "+")
    assert has_element?(view, "div > button > span", "add")
  end
end
