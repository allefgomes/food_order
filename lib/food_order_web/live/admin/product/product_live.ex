defmodule FoodOrderWeb.Admin.ProductLive do
  use FoodOrderWeb, :live_view
  alias FoodOrder.Products.Repositories.ProductsRepository

  def mount(_params, _session, socket) do
    products = ProductsRepository.list_products()
    socket = socket |> assign(products: products)

    {:ok, socket}
  end
end
