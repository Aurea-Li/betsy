class ReviewsController < ApplicationController

  before_action :find_product

  def index
    @reviews = @product.reviews
    @order_item = OrderItem.new(quantity: 1, status: 'pending')
  end

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)

    if @review.save
      flash[:status] = :success
      flash[:result_text] = "Review successfully saved."
      redirect_to product_reviews_path(@product.id)
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Invalid review. Please try again."
      render :new
    end
  end

  private

  def review_params
    params.require(:review)
    .permit(
      :name,
      :rating,
      :description,
      :product_id
    )
  end

  def find_product
    @product = Product.find_by(id: params[:product_id])
  end
end
