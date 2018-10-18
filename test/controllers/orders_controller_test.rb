require "test_helper"

describe OrdersController do

  let (:delete_all) {
    Order.all.each do |order|
      order.destroy
    end
  }

  let (:order_data) {
    {
      order: {
        status: 'paid',
        name: 'Ada',
        email: 'ada@adacademy.com',
        address: '123 Street Dr. Seattle, WA',
        cc_num: 1123384229389283,
        cc_cvv: 280,
        cc_expiration: 01-9-2020
      }
    }
  }

  describe "index" do
    it "succeeds with orders present" do
      get orders_path

      must_respond_with :success
    end

    it "succeeds with no orders present" do
      delete_all

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
      test_order = Order.new(order_data[:order])
      expect(test_order).must_be :valid?, "Order data was invalid. Please fix."

      expect{
        post orders_path, params: order_data
      }.must_change('Order.count', +1 )

      must_redirect_to order_path(Order.last)
    end
  end
end
