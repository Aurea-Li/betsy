require "test_helper"

describe Product do
  describe 'relations' do

    before do
      @p = Product.first
    end

    it 'has a merchant' do

      expect( @p.merchant ).must_be_instance_of Merchant

    end
    it 'has some reviews' do

      expect( @p.reviews ).must_respond_to :each
      expect( @p.reviews.first ).must_be_instance_of Review

    end

    it 'has some order items' do

      expect( @p.order_items ).must_respond_to :each
      expect( @p.order_items.first ).must_be_instance_of OrderItem

    end
  end

  describe 'validations' do

  end
end
