require "test_helper"

describe OrderItemsController do

  describe "guest user" do
    describe "index" do

  
      it "can access cart" do

        get order_items_path

        must_respond_with :success
      end
    end


    describe 'create' do
      it "creates new order for first item added to cart" do

      end

      it "successfully adds order item to existing order" do

      end
    end
  end
end
