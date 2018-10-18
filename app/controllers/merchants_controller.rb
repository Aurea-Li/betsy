class MerchantsController < ApplicationController
  def new
    @merchant = Merchant.new
  end

  def create
    @merchant = Merchant.new(merchant_params)
  end

  def show
    @merchant = Merchant.find_by(id: params[:id])
    render_404 unless @merchant
  end

  def index
    @merchants = Merchant.all
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:id])

    if @merchant.save(merchant_params)
      redirect_to merchant_path(@merchant)
    else
      render :edit
    end
  end

  def destroy
    @merchant.destroy
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
