class Order < ApplicationRecord
  STATUS = %w(pending paid complete cancelled)
  has_many :order_items


  def price
    return self.order_items.sum { |item| item.price}
  end

  def CC_num_last_four
    return self.cc_num.to_s[-4..-1]
  end

  def total_quantity
    return self.order_items.sum {|item| item.quantity }
  end
end
