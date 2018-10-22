class ReviewsController < ApplicationController

  before_action :find_product

  def index
    @reviews = product.reviews
  end

  private

  def find_product
    @product = Product.find_all(id: params[:product_id])
  end
end
