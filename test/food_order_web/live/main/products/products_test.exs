defmodule FoodOrderWeb.Main.ProductsTest do
  use FoodOrderWeb.ConnCase
  import Phoenix.LiveViewTest

  test "load page", %{conn: conn} do
    {:ok, view, html} = live(conn, Routes.main_path(conn, :index))

    assert html =~ "Todos os pratos"

    assert html =~
             "<div class=\"grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 col-gap-12 row-gap-16\">"

    assert element(view, "h1", "Todos os pratos")
           |> render() =~ "Todos os pratos"
  end
end
