defmodule FoodOrder.Products.Repositories.ProductsRepositoryTest do
  use FoodOrder.DataCase

  alias FoodOrder.Products.{Repositories.ProductsRepository, Schemas.Product}
  import FoodOrder.Factory

  describe "list_products/0" do
    test "should return empty list when haven't products in database" do
      Repo.delete_all(Product)
      expected_list_products = []

      products = ProductsRepository.list_products()

      assert products == expected_list_products
    end

    test "should return a list with a product when have a product in database" do
      {:ok, product} =
        Product.changeset(%{name: "Product 1", price: 1, size: "small"})
        |> Repo.insert()

      expected_list_products = [product]

      products_in_database = ProductsRepository.list_products()

      assert products_in_database == expected_list_products
    end
  end

  describe "create_product/1" do
    test "given a product, validates name, price and size as required" do
      expected_attrs_product = %{name: nil, price: nil, size: nil, description: nil}

      expected_result = %{
        name: ["can't be blank"],
        price: ["can't be blank"],
        size: ["can't be blank"]
      }

      {:error, changeset} = ProductsRepository.create_product(expected_attrs_product)

      assert expected_result == errors_on(changeset)
    end

    test "given a product with the same name should throw an error message" do
      expected_attrs_product = %{name: "P1", price: 1, size: "p"}
      expected_result = %{name: ["has already been taken"]}

      ProductsRepository.create_product(expected_attrs_product)
      {:error, changeset} = ProductsRepository.create_product(expected_attrs_product)

      assert expected_result == errors_on(changeset)
    end

    test "given a price less than 0 should throw an error message" do
      expected_attrs_product = %{name: "P1", price: -1, size: "small"}
      expected_result = %{price: ["must be greater than 0"]}

      {:error, changeset} = ProductsRepository.create_product(expected_attrs_product)

      assert expected_result == errors_on(changeset)
    end
  end

  describe "change_product/0" do
    test "should return a new product" do
      expected_result = %Product{
        description: nil,
        id: nil,
        inserted_at: nil,
        name: nil,
        price: nil,
        size: nil,
        updated_at: nil
      }

      changeset = ProductsRepository.change_product()

      assert expected_result == changeset.data
    end
  end

  describe "change_product/2" do
    test "should return a new product with the same name, price, description and size" do
      product_attrs = params_for(:product)

      changeset = ProductsRepository.change_product(%Product{}, product_attrs)

      assert changeset.changes.description == product_attrs.description
      assert changeset.changes.name == product_attrs.name
      assert changeset.changes.size == product_attrs.size
      assert changeset.changes.price == product_attrs.price
    end
  end

  describe "get!/1" do
    test "given an id returns a product" do
      expected_attrs_product = %{name: "P1", price: 1, size: "p", description: "Teste"}
      {:ok, product_expected} = ProductsRepository.create_product(expected_attrs_product)

      product = ProductsRepository.get!(product_expected.id)

      assert product_expected.id == product.id
      assert product_expected.name == product.name
      assert product_expected.price == product.price
      assert product_expected.size == product.size
      assert product_expected.description == product.description
    end
  end

  describe "delete/1" do
    test "given an id delete this product" do
      expected_attrs_product = %{name: "P1", price: 1, size: "p", description: "Teste"}
      {:ok, product} = ProductsRepository.create_product(expected_attrs_product)

      {:ok, %Product{}} = ProductsRepository.delete(product.id)

      assert_raise Ecto.NoResultsError, fn -> ProductsRepository.get!(product.id) end
    end
  end

  describe "update_product/2" do
    test "given attributes should update a product" do
      expected_attrs_product = %{name: "P1", price: 1, size: "p"}
      {:ok, product_expected} = ProductsRepository.create_product(expected_attrs_product)

      updated_attrs_product = %{
        name: "P1 updated",
        price: %Money{amount: 12, currency: :BRL},
        size: "big",
        description: "Teste 1"
      }

      {:ok, product} = ProductsRepository.update_product(product_expected, updated_attrs_product)

      assert product_expected.id == product.id
      assert updated_attrs_product.name == product.name
      assert updated_attrs_product.price == product.price
      assert updated_attrs_product.size == product.size
      assert updated_attrs_product.description == product.description
    end
  end
end
