alias FoodOrder.Accounts.User
alias FoodOrder.Repo
alias FoodOrder.Products.Repositories.ProductsRepository

%User{}
|> User.registration_changeset(%{
  email: "admin@test",
  password: "123123123123",
  role: "ADMIN"
})
|> Repo.insert!()

user =
  %User{}
  |> User.registration_changeset(%{
    email: "user@test",
    password: "123123123123"
  })
  |> Repo.insert!()

1..10
|> Enum.map(fn index ->
  ProductsRepository.create_product(%{
    name: "Product #" <> Integer.to_string(index),
    size: ["small", "big", "normal"] |> Enum.random(),
    price: [10, 20, 35] |> Enum.random()
  })
end)
