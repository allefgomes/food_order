defmodule FoodOrder.Products.Repositories.ProductsRepository do
  alias FoodOrder.Products.Schemas.Product
  alias FoodOrder.Repo

  def list_products, do: Repo.all(Product)

  def create_product(attrs \\ %{}) do
    attrs
    |> Product.changeset()
    |> Repo.insert()
  end
end
