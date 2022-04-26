defmodule FoodOrder.Products.Repositories.ProductsRepository do
  alias FoodOrder.Products.Schemas.Product
  alias FoodOrder.Repo
  import Ecto.Query, only: [from: 2]

  def list_products do
    query = from product in Product, order_by: product.name

    Repo.all(query)
  end

  def get!(id), do: Repo.get!(Product, id)

  def create_product(attrs \\ %{}) do
    attrs
    |> Product.changeset()
    |> Repo.insert()
  end

  def update_product(product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  def change_product(product, attrs \\ %{}), do: Product.changeset(product, attrs)

  def change_product, do: Product.changeset()
end
