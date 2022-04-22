defmodule FoodOrderWeb.Main.HeroTest do
  use FoodOrderWeb.ConnCase
  import Phoenix.LiveViewTest

  test "load hero", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.main_path(conn, :index))

    assert has_element?(view, "#hero-component")
    assert has_element?(view, "#hero-info > #hero-info-text-recomendation", "Faça sua compra!")
    assert has_element?(view, "#hero-info > h1", "Compre agora!")
    assert has_element?(view, "#hero-info > button", "Comprar")
    assert has_element?(view, "#hero-info-image > img")
  end
end
