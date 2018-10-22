class OrderItemsController < ApplicationController

  before_action :find_order_item, only: [:show, :edit, :update, :destroy]

  def index
    @order_items = OrderItem.where(status: 'pending', order_id: session[:order_id])
  end

  def new
    @order_item = OrderItem.new
  end

  # order item is created when added to cart
  def create

    @order_item = OrderItem.new(order_item_params)
    unless session[:order_id]
      order = Order.create(status: 'pending')
      session[:order_id] = order.id
    end

    order = Order.find_by(id: session[:order_id])

    if order

      duplicate_items = OrderItem.find_by(product_id: @order_item.product_id, status: 'pending')

      if duplicate_items
        quantity = duplicate_items.quantity + @order_item.quantity
        duplicate_items.update(quantity: quantity)

        flash[:status] = :success
        flash[:result_text] = "Quantity of #{@order_item.product.name} is updated."
      else

        @order_item.order_id = session[:order_id]
        # order item is created when added to cart
        if @order_item.save

          product = @order_item.product
          remaining_stock = product.stock - @order_item.quantity

          if product.update(stock: remaining_stock)

            flash[:status] = :success
            flash[:result_text] = "Item successfully added to cart. "
          else
            flash[:status] = :failure
            flash[:result_text] = "Quantity requested exceeds stock. Please try again."
          end

        else
          flash[:status] = :failure
          flash[:result_text] = "Error adding item to cart"
          # should other messages be displayed if it isn't successfully saved? i.e., 'quantity not available'
        end
      end

    else
      flash[:status] = :failure
      flash[:result_text] = "Order for cart is invalid. Please restart browser and try again. session order id: #{session[:order_id]}"
      session[:order_id] = nil
    end

    redirect_back fallback_location: products_path
  end

  def show;
  end

  def edit;
  end

  def update
    if @order_item.update(order_item_params)
      flash[:status] = :success
      flash[:result_text] = "Update was successful."
      # where to redirect to?
    else
      flash[:status] = :failure
      flash[:result_text] = "Update was not successful. Invalid input."
    end
    redirect_back fallback_location: order_items_path
  end

  def destroy
    @order_item.destroy
    flash[:status] = :success
    flash[:result_text] = "#{@order_item.product.name} successfully removed from cart."
    redirect_to order_items_path
  end

  private
  def order_item_params
    params.require(:order_item).permit(:quantity, :status, :product_id, :order_id)
  end

  def find_order_item
    @order_item = OrderItem.find_by(id: params[:id])
  end
end
