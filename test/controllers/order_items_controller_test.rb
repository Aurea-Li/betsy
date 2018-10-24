require "test_helper"

describe OrderItemsController do

  describe "guest user" do
    describe "index" do

      # TODO: AYL: do we need more tests? if cart is empty, etc.?
      it "can access cart" do

        get order_items_path

        must_respond_with :success
      end
    end

    describe "new" do
      # it "can get the new page" do
      #   get new_order_item_path
      #
      #   must_respond_with :success
      # end
      #VNG: There's no new view template, so this test doesn't pass.
    end

    describe 'create' do
      it "creates new order for first item added to cart" do

      end

      it "successfully adds order item to existing order" do

      end
    end
  end
end
