class ReviewsController < ApplicationController

  before_action :find_product

  def index
    @reviews = @product.reviews
  end

  def new
    @review = Review.new
  end

  def create

  end

  private

  def find_product
    @product = Product.find_by(id: params[:product_id])
  end
end
