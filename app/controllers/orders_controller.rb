class OrdersController < ApplicationController

  before_action :find_order, except: [:index, :new, :create]

  def index
    @orders = Order.all

  end

  def new
    @order = Order.new(status: 'paid')
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
    @order.update_attributes(order_params)

    if @order.save
      redirect_to order_path(@order.id)
    else
      render :edit, status: :bad_request
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_path
  end

  private

  def order_params
    params.require(:order).permit(
      :name,
      :email,
      :address,
      :cc_num,
      :cc_cvv,
      :cc_expiration
    )
  end

  def find_order
    @order = Order.find_by(id: params[:id])
    render_404 unless @order
  end
end
