require "test_helper"

describe OrdersController do

  let (:delete_all) {
    Order.all.each do |order|
      order.destroy
    end
  }

  describe "index" do
    it "should get index" do
      get orders_path

      must_respond_with :success
    end
  end

  describe "new" do
    it "can get the new page" do
      get new_order_path

      must_respond_with :success
    end
  end

  describe "create" do
    it "can create an order" do
      order_data = {
        order: {
          status: 'pending',
          name: 'Ada',
          email: 'ada@adacademy.com',
          address: '123 Street Dr. Seattle, WA',
          cc_num: 1123384229389283,
          cc_cvv: 280,
          cc_expiration: 01-09-2020
        }
      }

      
    end
  end
end
