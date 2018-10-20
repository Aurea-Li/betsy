class OrderItemsController < ApplicationController

  def index
    @order_items = OrderItem.where(status: :pending)

    

  end

  def new
    @order_item = OrderItem.new
  end


  def create

    puts "PARAMS IS #{params[:order_item]}"

    @order_item = OrderItem.new(order_item_params)

    unless session[:order_id]
      order = Order.create
      session[:order_id] = order.id
    end

    order = Order.find_by(id: session[:order_id])

    if order

      duplicate_items = OrderItem.find_by(product_id: @order_item.product_id)

      if duplicate_items
        quantity = duplicate_items.quantity + @order_item.quantity
        duplicate_items.update(quantity: quantity)

        flash[:status] = :success
        flash[:result_text] = "Quantity of #{@order_item.product.name} is updated."
      else

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
      end


    else
      flash[:status] = :failure
      flash[:result_text] = "Order for cart is invalid. Please restart browser and try again."
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
