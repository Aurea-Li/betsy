class CategoriesController < ApplicationController

  def new
    @category = Category.new
  end

  def create

  end

  private

  def category_params
    return params.require(:category).permit(
      :name
    )
  end

end
