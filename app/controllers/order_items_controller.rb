class OrderItemsController < ApplicationController

  before_action :find_order_item, only: [:show, :edit, :update, :destroy]

  def index
    @order_items = OrderItem.where(status: :pending, order_id: session[:order_id])
  end

  def new
    @order_item = OrderItem.new
  end

  # order item is created when added to cart
  def create
    @order_item = OrderItem.new(order_item_params)
    # order item is created when added to cart
    if @order_item.save
      flash[:success] = "Item added to cart."
      redirect_back #product show page
      # where do we want to go/redirect_to if an order item is successfully saved?
    else
<<<<<<< HEAD
      flash[:status] = :failure
      flash[:result_text] = "Order for cart is invalid. Cart has been wiped and reset. Please try again."
      session[:order_id] = nil
=======
      flash[:error] = "Error adding item to cart."
      redirect_back #product show page
      # should other messages be displayed if it isn't successfully saved? i.e., 'quantity not available'
>>>>>>> checkout-form
    end
  end


  def edit
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
    # where to redirect to?
  end

  private
  def order_item_params
    params.require(:order_item).permit(:quantity, :status)
  end

<<<<<<< HEAD
  def find_order_item
    @order_item = OrderItem.find_by(id: params[:id])
  end
=======
>>>>>>> checkout-form
end
