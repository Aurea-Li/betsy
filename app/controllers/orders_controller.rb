class OrdersController < ApplicationController

  # before_action :find_order

  def index
    @orders = Order.all

  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)

    if @order.save
      redirect_to order_path(@order.id)
    else
      render :edit, status: :bad_request
    end
  end


  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def order_params
    params.require(:order).permit(
      :status,
      :name,
      :email,
      :address,
      :cc_num,
      :cc_cvv,
      :cc_expiration
    )
  end
end
