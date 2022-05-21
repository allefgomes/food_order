defmodule FoodOrderWeb.Admin.ProductLive.Show do
  use FoodOrderWeb, :live_view
  alias FoodOrder.Products.Repositories.ProductsRepository

  def mount(_params, _session, socket), do: {:ok, socket}

  def handle_params(%{"id" => id}, _uri, socket) do
    product = ProductsRepository.get!(id)

    {:noreply, socket |> assign(product: product) |> assign(page_title: "Show | #{product.name}")}
  end
end
