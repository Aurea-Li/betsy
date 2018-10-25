class OrdersController < ApplicationController

  before_action :find_order, except: [:index, :new, :create]

  def index
    @orders = Order.all

    if params[:search]
      @orders = Order.search(params[:search])
    else
      @orders = Order.all
    end
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
    @order.update_attributes(order_params)
    @order.set_paid

    if @order.save
      session[:order_id] = nil

      flash[:status] = :success
      flash[:result_text] = "Order successfully finalized. Please save your order number - ##{@order.id}."
      redirect_to order_path(@order.id)
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Order information is invalid. Please try again."
      render :edit, status: :bad_request
    end
  end

  def destroy
    @order.destroy
    flash[:status] = :success
    flash[:result_text] = "Your order has been cancelled."
    redirect_to root_path
  end

  def customerinfo
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

  def find_order
    @order = Order.find_by(id: params[:id])
    render_404 unless @order
  end
end
