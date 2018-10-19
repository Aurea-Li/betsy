class SessionsController < ApplicationController
  def create
    merch_hash = request.env['omniauth.auth']

    merchant = Merchant.find_by(uid: merch_hash[:uid], provider: merch_hash[:provider])

    if merchant
      flash[:success] = "Welcome   #{merchant.username}"
    else
      merchant = Merchant.create_from_github(merch_hash)

      if merchant.save
        flash[:success] = "Logged in as merchant #{merchant.username}"
      else
        flash[:error] = "Could not create new account: #{merchant.errors.messages}"
        redirect_to root_path
        return
      end
    end

    session[:user_id] = merchant.id
    redirect_to root_path
  end

  def logout
    session[:user_id] = nil
    flash[:success] = "Successfully logged out"
    redirect_to root_path
  end
end
