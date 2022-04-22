defmodule FoodOrder.Factory do
  use ExMachina.Ecto, repo: FoodOrder.Repo

  def product_factory do
    %FoodOrder.Products.Schemas.Product{
      description: Faker.Lorem.paragraph(),
      name: Faker.Food.dish(),
      price:
        [
          %Money{amount: 100, currency: :BRL},
          %Money{amount: 200, currency: :BRL},
          %Money{amount: 300, currency: :BRL}
        ]
        |> Enum.random(),
      size: ["small", "big", "normal"] |> Enum.random()
    }
  end

  def invalid_product_factory do
    %FoodOrder.Products.Schemas.Product{
      description: nil,
      name: nil,
      price: nil,
      size: nil
    }
  end
end
