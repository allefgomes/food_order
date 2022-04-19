# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     FoodOrder.Repo.insert!(%FoodOrder.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias FoodOrder.Products.Repositories.ProductsRepository

1..10
|> Enum.map(fn index ->
  ProductsRepository.create_product(%{
    name: "Product #" <> Integer.to_string(index),
    size: ["small", "big", "normal"] |> Enum.random(),
    price: [10, 20, 35] |> Enum.random()
  })
end)
