defmodule FoodOrderWeb.Main.HeroTest do
  use FoodOrderWeb.ConnCase
  import Phoenix.LiveViewTest

  test "load page", %{conn: conn} do
    {:ok, view, html} = live(conn, Routes.main_path(conn, :index))

    assert html =~ "<h6 class=\"text-lg\" id=\"hero-info-text\"><em>Faça sua compra!</em></h6>"

    assert element(view, "h6", "Faça sua compra")
           |> render() =~ "Faça sua compra!"

    assert element(view, "h1", "Compre agora!!")
           |> render() =~ "Compre agora!!!"

    assert element(view, "button.btn-primary", "Comprar")
           |> render() =~ "Comprar"
  end
end
