require "test_helper"

describe SessionsController do
  it 'can sucessfully log in with github as an existing user' do
    merchant = merchants(:dogdays)

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_merchant_hash(merchant))

    get auth_callback_path(:github)

    must_redirect_to root_path

    expect(session[:user_id]).must_equal merchant.id
    # expect(flash[:success]).must_equal "Logged in as merchant #{merchant.username}"
    # VNG - We need to fix flash.
  end

  it 'creates a new user sucessfully when logging in with a new valid user' do

    start_count = Merchant.count

    new_user = Merchant.new(username: "new user", email: "email@email.com", uid: 10, provider: "github")

    expect(new_user.valid?).must_equal true

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new( mock_merchant_hash( new_user ) )


    get auth_callback_path(:github)
    must_redirect_to root_path

    expect(Merchant.count).must_equal start_count + 1

    expect( session[:user_id] ).must_equal Merchant.last.id

  end

  it 'does not create a new user when logging in with a new invalid user' do
    start_count = Merchant.count

    invalid_new_user = Merchant.new(username: nil, email: nil)

    expect(invalid_new_user.valid?).must_equal false

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new( mock_merchant_hash( invalid_new_user ) )

  get auth_callback_path(:github)

  must_redirect_to root_path
  expect( session[:user_id] ).must_equal nil
  expect( Merchant.count ).must_equal start_count
  end
end
