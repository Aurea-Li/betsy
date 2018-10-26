require "test_helper"
describe OrderItemsController do

  let (:order_item_data) {
    {
      order_item: {
        quantity: 2,
        status: 'pending',
        product_id: Product.first.id
      }
    }
  }

  let (:prod) {
    Product.find(order_item_data[:order_item][:product_id])
  }

  let (:existing_item) {
    order_items(:six)
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

        stock = prod.stock

        order_item_data[:order_item][:quantity] = stock + 1

        expect{
          post order_items_path, params: order_item_data
        }.wont_change('OrderItem.count')

        expect(flash[:status]).must_equal :failure



      end

      it 'returns error if trying to add existing order item that exceeds stock' do

        expect {
          post order_items_path, params: order_item_data
        }.must_change('OrderItem.count', +1)

        remaining_stock = prod.stock - order_item_data[:order_item][:quantity]

        order_item_data[:order_item][:quantity] = remaining_stock + 1


        expect {
          post order_items_path, params: order_item_data
        }.wont_change('OrderItem.count')

        expect(flash[:status]).must_equal :failure
        expect(flash[:result_text]).must_equal "Quantity requested exceeds stock. Please try again."

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

    describe "update" do

      it 'successfully updates order if decreasing quantity, adds back into stock' do

        order_item_data[:order_item][:quantity] -= 1

        initial_stock = existing_item.product.stock

        expect{
          patch order_item_path(existing_item.id), params: order_item_data
        }.wont_change('OrderItem.count')

        expect(flash[:status]).must_equal :success

        existing_item.reload
        expect(existing_item.product.stock).must_equal(initial_stock + 1)

      end

      it 'does not update order if input is invalid' do

        order_item_data[:order_item][:quantity] = -1


        patch order_item_path(existing_item.id), params: order_item_data

        expect(flash[:status]).must_equal :failure

      end

      it "does not update order if quantity exceeds stock" do
        remaining_stock = existing_item.product.stock

        order_item_data[:order_item][:quantity] += (remaining_stock + 1)

        patch order_item_path(existing_item.id), params: order_item_data

        expect(flash[:status]).must_equal :failure

      end
    end

    describe "destroy" do

      it "successfully destroys existing order item, restocks product" do


        quantity = existing_item.quantity
        stock = existing_item.product.stock
        prod = existing_item.product

        expect{
          delete order_item_path(existing_item.id)
        }.must_change('OrderItem.count', -1)

        prod.reload

        must_redirect_to order_items_path
        expect(flash[:status]).must_equal :success
        expect(prod.stock).must_equal(quantity + stock )


      end

      it "raise routingerror if order item id is invalid" do

        existing_item.destroy

        expect{
          delete order_item_path(existing_item.id)
        }.must_raise(ActionController::RoutingError)

      end
    end

    describe "status" do

      before do
        perform_login(merchants(:dogdays))
      end

      it "successfully updates order item status" do


        post order_items_status_path(existing_item.id)

        existing_item.reload

        expect(existing_item.status).must_equal 'complete'
        expect(flash[:status]).must_equal :success
        must_redirect_to dashboard_path(merchants(:dogdays).id)
      end


    end


  end
end
