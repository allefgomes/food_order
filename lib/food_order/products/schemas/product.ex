defmodule FoodOrder.Products.Schemas.Product do
  alias FoodOrder.Products.Schemas.ProductImage

  use Ecto.Schema

  import Ecto.Changeset
  import Waffle.Ecto.Schema

  @fields ~w/description/a
  @required_fields ~w/name price size/a
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "products" do
    field :name, :string
    field :price, Money.Ecto.Amount.Type
    field :size, :string
    field :description, :string
    field :product_url, ProductImage.Type

    timestamps()
  end

  def changeset(attrs \\ %{}), do: changeset(%__MODULE__{}, attrs)

  def changeset(product, attrs) do
    product
    |> cast(attrs, @fields ++ @required_fields)
    |> cast_attachments(attrs, [:product_url])
    |> validate_required(@required_fields)
    |> unique_constraint(:name, name: :products_name_index)
    |> validate_money(:price)
  end

  defp validate_money(changeset, field) do
    validate_change(changeset, field, fn
      _, %Money{amount: price} when price > 0 -> []
      _, _ -> [price: "must be greater than 0"]
    end)
  end
end
