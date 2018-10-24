class MerchantsController < ApplicationController

  def new
    @merchant = Merchant.new
  end

  def create
    @merchant = Merchant.new(merchant_params)

    if @merchant.save
      flash[:status] = :success
      flash[:result_text] = "Successfully created new merchant"
      redirect_to merchant_path(@merchant)
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Merchant not created. Please try again"
      redirect_to :index, status: :bad_request
    end
  end


  def show
    @merchant = Merchant.find_by(id: params[:id])
    render_404 unless @merchant
  end


  def index
    @merchants = Merchant.all
  end

  def dashboard
    @merchant = Merchant.find_by(id: params[:id])
    render_404 unless @merchant
  end

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
