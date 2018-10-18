require "test_helper"

describe ProductsController do
  # it "must be a real test" do
  #   flunk "Need real tests"
  # end
  it "succeeds when there are no products" do
    get products_path
    
    must_respond_with :success
  end
end
