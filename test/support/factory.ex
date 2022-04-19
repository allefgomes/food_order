defmodule FoodOrder.Factory do
  use ExMachina.Ecto, repo: FoodOrder.Repo

  def product_factory do
    %FoodOrder.Products.Schemas.Product{
      description: Faker.Lorem.paragraph(),
      name: Faker.Food.dish(),
      price: [100, 200, 300] |> Enum.random(),
      size: ["small", "big", "normal"] |> Enum.random()
    }
  end
end
