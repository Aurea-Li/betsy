class OrdersController < ApplicationController

  # before_action :find_order

  def index
    @orders = Order.all

  end

  def new
    @order = Order.new
  end

  def create

  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
