require "test_helper"

describe MerchantsController do
  it "should get index" do
    get merchants_path
    must_respond_with :success
  end

end
