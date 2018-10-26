require "test_helper"
describe OrderItemsController do

  let (:order_item_data) {
    {
      order_item: {
        quantity: 1,
        status: 'pending',
        product_id: Product.first.id
      }
    }
  }

  describe "guest user" do
    describe "index" do


      it "can access cart" do

        get order_items_path

        must_respond_with :success
      end
    end


    describe 'create' do
      it "creates new order for first item added to cart" do

        expect {
          post order_items_path, params: order_item_data
        }.must_change('Order.count', +1)


        expect(flash[:status]).must_equal :success
        expect(flash[:result_text]).must_equal "Item successfully added to cart. "

        expect(session[:order_id]).must_equal OrderItem.last.order_id

        must_respond_with :redirect
      end

      it "successfully adds order item to existing order" do

        merchant = merchants(:dogdays)
        perform_login(merchant)

        order_item_data = {
          order_item: {
            quantity: 3,
            status: 'pending',
            product_id: products(:product_two).id,
            order_id: orders(:merchant).id
          }
        }

        test_item = OrderItem.new(order_item_data[:order_item])
        test_item.must_be :valid?, "OrderItem data was invalid. Please fix this test."

        session[:order_id] = orders(:merchant).id

        before = OrderItem.count

        post order_items_path(order_item_data)

        expect {
          post order_items_path, params: order_item_data
        }.wont_change('Order.count')

        expect(OrderItem.count).must_equal before + 1

        expect(flash[:status]).must_equal :success
        expect(flash[:result_text]).must_include "Cart successfully updated"

        must_respond_with :redirect

      end

      it "shows an error if the quantity is greater than the product's stock" do

        prod = Product.find(order_item_data[:order_item][:product_id])

        stock = prod.stock

        order_item_data[:order_item][:quantity] = stock + 1

        expect{
          post order_items_path, params: order_item_data
        }.wont_change('OrderItem.count')

        expect(flash[:status]).must_equal :failure



      end

      it 'returns error if invalid order item' do

        order_item_data[:order_item][:quantity] = -1

        test_item = OrderItem.new(order_item_data[:order_item])
        test_item.wont_be :valid?, "OrderItem data is not invalid. Please fix."

        expect{
          post order_items_path(order_item_data)
        }.wont_change('OrderItem.count')

        expect(flash[:status]).must_equal :failure


      end
    end
  end
end
