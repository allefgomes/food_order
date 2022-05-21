defmodule FoodOrderWeb.Admin.Product.FormComponent do
  use FoodOrderWeb, :live_component
  alias FoodOrder.Products.Repositories.ProductsRepository

  def update(%{product: product} = assigns, socket) do
    changeset = ProductsRepository.change_product(product)
    sizes = [Small: "small", Bigger: "bigger", Normal: "normal"]

    socket =
      socket
      |> assign(assigns)
      |> assign(sizes: sizes)
      |> assign(changeset: changeset)
      |> assign(product: product)

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
    action = socket.assigns.action

    save(socket, action, product_params)
  end

  def save(socket, :new, product_params) do
    case ProductsRepository.create_product(product_params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product has created!")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def save(socket, :edit, product_params) do
    case ProductsRepository.update_product(socket.assigns.product, product_params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product updated!")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
