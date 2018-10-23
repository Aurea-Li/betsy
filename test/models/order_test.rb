require "test_helper"

describe Order do
  describe 'relations' do

    before do
      @o = orders(:bob)
    end

    it 'has some order items' do
      expect( @o.order_items ).must_respond_to :each

      @o.order_items.each do |order_item|
        expect(order_item).must_be_instance_of OrderItem
      end
    end


  end

  describe 'validations' do
    before do
      @o = orders(:bob)
    end

    describe 'conditional validation: order is not pending' do

      it 'is valid when all required fields are present' do
        expect( @o ).must_be :valid?

      end

      it 'is invalid without a name' do

        @o.name = nil

        expect( @o ).wont_be :valid?

      end

      it 'is invalid without an email' do

        @o.email = nil

        expect( @o ).wont_be :valid?

      end

      it 'is invalid without an address' do

        @o.address = nil

        expect( @o ).wont_be :valid?

      end

      it 'is invalid without a cc_num' do

        @o.cc_num = nil

        expect( @o ).wont_be :valid?

      end

      it 'is invalid without a cc_cvv' do

        @o.cc_cvv = nil

        expect( @o ).wont_be :valid?

      end

      it 'is invalid without a cc_expiration' do

        @o.cc_expiration = nil

        expect( @o ).wont_be :valid?

      end
    end

    describe 'unconditional validation' do

      before do
        @o = orders(:incomplete_order)
      end

      it 'is valid if status is present and true' do
        expect( @o ).must_be :valid?
      end

      it 'is invalid if status is not a valid status' do
        @o.status = 'foo'

        expect( @o ).wont_be :valid?
      end
    end

  end
end
