class OrderItemsController < ApplicationController

  def index
    @order_items = OrderItem.where(status: :pending)
  end

  def new
    @order_item = OrderItem.new
  end

  # order item is created when added to cart
  #TODO: sessions[:order_id] is invalid order
  #TODO: avoid duplicate order_items for same product
  def create

    puts "PARAMS IS #{params[:order_item]}"

    @order_item = OrderItem.new(order_item_params)

    unless session[:order_id]
      order = Order.create
      session[:order_id] = order.id
    end

    @order_item.order_id = session[:order_id]
    # order item is created when added to cart


    if @order_item.save
      flash[:status] = :success
      flash[:result_text] = "Item successfully added to cart. "

    else
      flash[:status] = :failure
      flash[:result_text] = "Error adding item to cart"
      # should other messages be displayed if it isn't successfully saved? i.e., 'quantity not available'
    end

    redirect_back fallback_location: products_path
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
    params.require(:order_item).permit(:quantity, :status, :product_id, :order_id)

  end

end
