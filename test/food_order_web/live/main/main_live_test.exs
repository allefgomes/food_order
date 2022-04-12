defmodule FoodOrderWeb.MainLiveTest do
  use FoodOrderWeb.ConnCase
  import Phoenix.LiveViewTest

  test "load page", %{conn: conn} do
    {:ok, view, html} = live(conn, Routes.main_path(conn, :index))

    assert html =~ "<div id=\"menu\">"
    assert html =~ "<div class=\"w-1/2\" id=\"hero-info\">"

    assert render(view) =~ "Faça sua compra"
    assert render(view) =~ "Compre agora!!!"

    assert element(view, "button.btn-primary", "Comprar")
           |> render() =~ "Comprar"
  end
end
