defmodule FoodOrderWeb.Admin.ProductLive do
  use FoodOrderWeb, :live_view
  alias FoodOrder.Products.Repositories.ProductsRepository
  alias FoodOrder.Products.Schemas.Product
  alias FoodOrderWeb.Admin.Product.FormComponent

  def mount(_params, _session, socket) do
    products = ProductsRepository.list_products()
    socket = socket |> assign(products: products)

    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    live_action = socket.assigns.live_action

    {:noreply, apply_action(socket, live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Create new Product")
    |> assign(product: %Product{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "List Products")
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    product = ProductsRepository.get!(id)

    socket
    |> assign(:page_title, "Edit Product - #{product.name}")
    |> assign(:product, product)
  end
end
