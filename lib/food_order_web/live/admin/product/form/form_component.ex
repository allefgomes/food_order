defmodule FoodOrderWeb.Admin.Product.FormComponent do
  use FoodOrderWeb, :live_component
  alias FoodOrder.Products.Repositories.ProductsRepository
  alias FoodOrder.Products.Schemas.Product

  def update(assigns, socket) do
    changeset = ProductsRepository.change_product()

    socket =
      socket
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

  def handle_event("save", %{"product" => product_params}, socket) do
    case ProductsRepository.create_product(product_params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product has created")
         |> push_redirect(to: Routes.admin_product_path(socket, :index))}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
