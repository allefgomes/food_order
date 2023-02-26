defmodule FoodOrderWeb.Main.Products do
  alias FoodOrder.Products.Repositories.ProductsRepository
  alias FoodOrderWeb.Main.Products.Product
  use FoodOrderWeb, :live_component

  def update(assigns, socket) do
    products = ProductsRepository.list_products()
    socket = socket |> assign(assigns) |> assign(products: products)
    {:ok, socket}
  end
end
