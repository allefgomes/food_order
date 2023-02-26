defmodule FoodOrderWeb.Admin.Product.FormComponent do
  use FoodOrderWeb, :live_component
  alias FoodOrder.Products.Repositories.ProductsRepository

  @upload_configs [accept: ~w/.png .jpeg .jpg/, max_entries: 2, max_file_size: 10_000_000]

  def update(%{product: product} = assigns, socket) do
    changeset = ProductsRepository.change_product(product)
    sizes = [Small: "small", Bigger: "bigger", Normal: "normal"]

    socket =
      socket
      |> assign(assigns)
      |> assign(sizes: sizes)
      |> assign(changeset: changeset)
      |> allow_upload(:photo, @upload_configs)
      |> assign(product: product)

    {:ok, socket}
  end

  def handle_event("cancel", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :photo, ref)}
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
    product_params = build_photo_to_upload(socket, product_params)

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

  defp build_photo_to_upload(socket, product_params) do
    socket
    |> consume_uploaded_entries(:photo, fn %{path: path}, entry ->
      file_name = get_file_name(entry)
      dest = Path.join("/tmp", file_name)
      File.cp!(path, dest)
''
      file_upload = %Plug.Upload{
        content_type: entry.client_type,
        filename: entry.client_name,
        path: dest
      }

      {:ok, file_upload}
    end)
    |> add_file_upload(product_params)
  end

  defp add_file_upload([], product_params), do: product_params

  defp add_file_upload([file_upload | _], product_params) do
    Map.put(product_params, "product_url", file_upload)
  end

  defp get_file_name(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    "#{entry.uuid}.#{ext}"
  end
end
