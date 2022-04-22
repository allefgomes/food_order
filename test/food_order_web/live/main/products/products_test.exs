defmodule FoodOrderWeb.Main.ProductsTest do
  use FoodOrderWeb.ConnCase
  import Phoenix.LiveViewTest

  test "load products", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.main_path(conn, :index))

    assert has_element?(view, "h1", "Todos os pratos")
    assert has_element?(view, "#products-component")
  end
end
