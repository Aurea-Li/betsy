class MerchantsController < ApplicationController

  def new
    @merchant = Merchant.new
  end


  def create
    @merchant = Merchant.new(merchant_params)

    if @merchant.save
      flash[:success] = "Successfully created new merchant"
      redirect_to merchant_path(@merchant)
    else
      flash.now[:error] = "Merchant not created. Please try again"
      render :new, status: :bad_request
    end
  end


  def show
    @merchant = Merchant.find_by(id: params[:id])
    head :not_found unless @merchant
  end


  def index
    @merchants = Merchant.all
  end

  # def edit
  #   @merchant = Merchant.find(params[:id])
  # end
  #
  # def update
  #   @merchant = Merchant.find(params[:id])
  #
  #   if @merchant.save(merchant_params)
  #     flash[:success] = "Successfully updated merchant."
  #     redirect_to merchant_path(@merchant)
  #   else
  #     flash.now[:error] = "Invalid merchant information"
  #     render :edit, status: :not_found
  #   end
  # end

  # def destroy
  #   # Add sessions id / OAuth handling
  #   @merchant.destroy
  #   redirect_to merchants_path
  # end

private

  def merchant_params
   return params.require(:merchant).permit(
      :username,
      :email,
      :uid,
      :provider
    )
  end

end
