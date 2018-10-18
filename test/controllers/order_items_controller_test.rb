require "test_helper"

describe OrderItemsController do
  describe 'new' do
    it 'succeeds' do
      get new_order_item_path
      must_respond_with :success
    end
  end
end
