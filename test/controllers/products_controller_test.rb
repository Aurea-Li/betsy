require "test_helper"
require 'pry'

describe ProductsController do
  # it "must be a real test" do
  #   flunk "Need real tests"
  # end
  describe "index" do
    it "succeeds when there are no products" do
      get products_path

      must_respond_with :success
    end

    it "succeeds when there are products" do
    end
  end

  describe "show" do
    it "should respond with success for showing an existing product" do

      product = products.first
      id = product.id

      get product_path(id)

      must_respond_with :success
    end

    it "should respond with not found for showing a non-existing product" do

      product = products.first
      id = product.id

      get product_path(id)
      must_respond_with :success
      # Act
      product.delete

      get product_path(id)

      # Assert
      must_respond_with :missing
    end

  end

  describe "new" do
    it "successfully retrieves new page" do

    get new_product_path

    must_respond_with :success

    end
  end

  describe "create" do
    it "creates new product when given valid data" do
      merchant = merchants(:dogdays)

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_merchant_hash(merchant))

      get auth_callback_path(:github)

      product_hash = {
        product: {
          name: "Test product",
          price: 3.50,
          stock: 5,
          active: true,
          category: "cats"
         }
      }

      test_product = Product.new(product_hash[:product])
      test_product.must_be :valid?, "Book data was invalid. Please come fix this test."

      expect {
        post products_path, params: product_hash }.must_change 'Product.count', 1

      must_respond_with :redirect

      expect(Product.count).must_equal 3
      expect(Product.last.name).must_equal product_hash[:product][:name]
    end
  end

  describe "edit" do
    it "responds with success for an existing product" do
      get edit_product_path(Product.first)

      must_respond_with :success
    end

    it "responds with not_found for a product that doesn't exist" do
      product = Product.first.destroy

      get edit_product_path(product)

      must_respond_with :not_found
    end
  end

  describe "update" do
    it "should show success when showing an existing product" do

      product = products.first

      get product_path(product.id)

      must_respond_with :success
    end

    it "should return error message if product doesn't exist" do

      product = products.first
      id = product.id
      product.destroy

      get product_path(id)

      must_respond_with :not_found
    end
  end

  describe "destroy" do
    it "can destroy an existing product" do
      product = products.first

      expect {
        delete product_path(product)
      }.must_change('Product.count', -1)

      must_respond_with :redirect
      must_redirect_to products_path
    end
  end
end
