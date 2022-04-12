defmodule FoodOrderWeb.Main.Products.ProductTest do
  use FoodOrderWeb.ConnCase
  import Phoenix.LiveViewTest

  test "load page", %{conn: conn} do
    {:ok, _view, html} = live(conn, Routes.main_path(conn, :index))

    assert html =~ "Produto com nome"
    assert html =~ "<span class=\"ml-4\">add</span>"
  end
end
