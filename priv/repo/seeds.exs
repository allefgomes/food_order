alias FoodOrder.Accounts.User
alias FoodOrder.Repo
alias FoodOrder.Products.Repositories.ProductsRepository

%User{}
|> User.registration_changeset(%{
  email: "admin@allef.com",
  password: "velhasuja123",
  role: "ADMIN"
})
|> Repo.insert!()

%User{}
|> User.registration_changeset(%{
  email: "user@allef.com",
  password: "velhasuja123"
})
|> Repo.insert!()

Enum.each(1..200, fn _ ->
  image = :rand.uniform(4)

  %{
    name: Faker.Food.dish(),
    description: Faker.Food.description(),
    price: :random.uniform(10_000),
    size: "small",
    product_url: %Plug.Upload{
      content_type: "image/png",
      filename: "product_#{image}.jpg",
      path: "priv/static/images/product_#{image}.jpg"
    }
  }
  |> ProductsRepository.create_product()
end)
