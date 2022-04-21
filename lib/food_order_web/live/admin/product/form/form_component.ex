defmodule FoodOrderWeb.Admin.Product.FormComponent do
  use FoodOrderWeb, :live_component
  alias FoodOrder.Products.Repositories.ProductsRepository
  alias FoodOrder.Products.Schemas.Product

  def update(assigns, socket) do
    changeset = ProductsRepository.change_product()
    socket = socket
             |> assign(assigns)
             |> assign(changeset: changeset)
             |> assign(product: %Product{})

    {:ok, socket}
  end

  def handle_event("validate", %{"product" => product_params}, socket) do
    changeset =
      socket.assigns.product
      |> ProductsRepository.change_product(product_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end
end
