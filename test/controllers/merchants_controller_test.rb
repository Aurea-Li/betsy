require "test_helper"
require 'pry'
describe MerchantsController do

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

  let (:merchant) {
    merchants(:dogdays)
  }

  describe "index" do
    it "should get index" do

      get merchants_path

      must_respond_with :success
    end
  end

  describe "show" do


    it "should respond with success for showing an existing merchant" do

      get merchant_path(merchant.id)
      must_respond_with :success
    end

    it "should respond with not found for showing a non-existant merchant" do

      merchant.destroy

      expect{
        get merchant_path(merchant.id)
      }.must_raise(ActionController::RoutingError)

    end
  end

  describe "dashboard" do
    it "should respond with success for showing an existing merchant" do

      get dashboard_path(merchant)

      must_respond_with :success
    end

    it "raise error for showing a non existant merchant" do
      merchant.destroy

      expect{
        get merchant_path(merchant.id)
      }.must_raise(ActionController::RoutingError)

    end
  end
end
