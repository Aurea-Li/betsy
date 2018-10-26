class OrderItemsController < ApplicationController

  before_action :find_order_item, only: [:show, :edit, :update, :destroy, :status]

  def index
    @order_items = OrderItem.where(status: 'pending', order_id: session[:order_id])
  end


  def create
    @order_item = OrderItem.new(order_item_params)

    unless session[:order_id]
      order = Order.create(status: 'pending')
      session[:order_id] = order.id
    end

    order = Order.find_by(id: session[:order_id])

    if order

      duplicate_item = OrderItem.find_by(product_id: @order_item.product_id, order: order, status: 'pending')

      if duplicate_item

        quantity = @order_item.quantity + duplicate_item.quantity

        if quantity < duplicate_item.product.stock

          duplicate_item.update(quantity: quantity)
          @order_item.reduce_stock(duplicate_item)

          flash[:status] = :success
          flash[:result_text] = "Cart successfully updated - added #{@order_item.quantity} of #{@order_item.product.name}."
        else

          flash[:status] = :failure
          flash[:result_text] = "Quantity requested exceeds stock. Please try again."
        end
      else

        prod = @order_item.product

        available_stock = prod.stock

        if available_stock >= @order_item.quantity

          @order_item.update(order: order)

          if @order_item.save

            @order_item.order_id = session[:order_id]
            @order_item.reduce_stock

            flash[:status] = :success
            flash[:result_text] = "Item successfully added to cart. "
          else

            flash[:status] = :failure
            flash[:result_text] = "Error added item to cart."
          end


        else



          flash[:status] = :failure
          flash[:result_text] = "Quantity requested exceeds stock. Please try again."
        end
      end

    end

    redirect_back fallback_location: products_path
  end

  def show;
  end

  def edit;
  end

  def update
    old_quantity = @order_item.quantity
    new_quantity = order_item_params[:quantity].to_i


    diff_quantity = new_quantity - old_quantity
    curr_stock = @order_item.product.stock
    new_stock = curr_stock - diff_quantity

    if @order_item.product.update(stock: new_stock)

      if @order_item.update(order_item_params)

        flash[:status] = :success
        flash[:result_text] = "Update was successful."

      else
        flash[:status] = :failure
        flash[:result_text] = "Update was not successful. Invalid input."
      end
    else
      flash[:status] = :failure
      flash[:result_text] = "Quantity requested exceeds stock. Please try again."
    end

    redirect_back fallback_location: order_items_path
  end

  def destroy
    @order_item.destroy
    @order_item.restock_product
    flash[:status] = :success
    flash[:result_text] = "#{@order_item.product.name} successfully removed from cart."
    redirect_to order_items_path
  end

  def status
    if @order_item.update(status: 'complete')
      flash[:status] = :success
      flash[:result_text] = "Order item number #{@order_item.id} has been completed."
    else
      flash[:status] = :failure
      flash[:result_text] = "There was a problem. Order #{@order_item.id} has not been updated."
    end
    redirect_to dashboard_path(session[:user_id])
  end

  private
  def order_item_params
    params.require(:order_item).permit(:quantity, :status, :product_id, :order_id)
  end

  def find_order_item
    @order_item = OrderItem.find_by(id: params[:id])
    render_404 unless @order_item
  end
end
