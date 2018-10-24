require "test_helper"
require 'pry'
describe MerchantsController do

  let(:bad_merchant_id) { Merchant.first.destroy.id
  }

  let(:merchant_data) {
    {
      merchant:
      {
        username: 'testername',
        email: 'testername@gmail.com',
        uid: 7,
        provider: 'github'
      }
    }
  }

  describe "index" do
    it "should get index" do

      get merchants_path

      must_respond_with :success
    end
  end

  # VNG: Should we delete the new action? I don't think we need it.
  # describe "new" do
  #   it "can get the new page" do
  #
  #     get new_merchant_path
  #
  #     must_respond_with :success
  #   end
  # end

  describe "create" do
    it "can create a merchant with valid data" do

      test_merchant = Merchant.new(merchant_data[:merchant])
      test_merchant.must_be :valid?, "Merchant data was invalid. Please come fix this test."

      expect {
        post merchants_path, params: merchant_data
      }.must_change('Merchant.count', +1)

      must_redirect_to merchant_path(Merchant.last)
    end

    it "does not create a merchant with invalid data" do
      merchant_data[:merchant][:email] = nil


      merchant = Merchant.new(merchant_data[:merchant])

      merchant.wont_be :valid?, "Merchant data was valid. Please come fix this test."

      expect {
        post merchants_path, params: merchant_data
      }.wont_change('Merchant.count')

      must_respond_with :bad_request
    end
  end


  describe "show" do
    it "should respond with success for showing an existing merchant" do
      existing_merchant = merchants(:dogdays)
      get merchant_path(existing_merchant.id)
      must_respond_with :success
    end

    it "should respond with not found for showing a non-existant merchant" do
      get merchant_path(bad_merchant_id)
      must_respond_with :not_found
    end
  end

  describe "index" do
    it "should get index" do
      get merchants_path
      must_respond_with :success
    end
  end

end
