class OrderItemsController < ApplicationController

  def index
    @order_items = OrderItem.all
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
      redirect_back
      # where do we want to go/redirect_to if an order item is successfully saved?
    else
      flash[:error] = "Error adding item to cart."
      # should other messages be displayed if it isn't successfully saved? i.e., 'quantity not available'
    end
  end

  def show
    @order_item = OrderItem.find_by(id: params[:id])
  end

  def edit
    @order_item = OrderItem.find_by(id: params[:id])
  end

  def update
    @order_item = OrderItem.find_by(id: params[:id])
    if @order_item.update(order_item_params)
      flash[:success] = "Successful update."
      # where to redirect to?
    else
      render :edit
      # what do we want to render here?
    end
  end

  def destroy
    @order_item = OrderItem.find_by(id: params[:id])

    @order_item.destroy
    # where to redirect to?
  end

  private
  def order_item_params
    params.require(:order_item).permit(:quantity, :status)
  end

end
