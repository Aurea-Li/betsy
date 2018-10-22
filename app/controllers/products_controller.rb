class ProductsController < ApplicationController

  before_action :find_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.where(active: true).paginate(page: params[:page], per_page: 16)
  end

  def show
    @order_item = OrderItem.new
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:status] = :success
      flash[:result_text] = "Product successfully created."
      redirect_to products_path
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Product info invalid. Please try again."
      render :new
    end
  end

  def edit;
  end

  def update
    if @product.update(product_params)
      flash[:status] = :success
      flash[:result_text] = "Product successfully edited."
      redirect_to product_path(@product)
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Product info invalid. Please try again."
      render :edit
    end
  end

  def destroy
    @product.destroy
    flash[:status] = :success
    flash[:result_text] = "Product successfully deleted."
    redirect_to products_path
  end

  def product_params
    params.require(:product).permit(:name, :price, :photo, :stock, :active, :category, :rating, :merchant_id)
  end

  def find_product
    @product = Product.find_by(id: params[:id])
    head :not_found unless @product
  end

end
