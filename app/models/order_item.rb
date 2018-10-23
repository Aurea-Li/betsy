class OrderItem < ApplicationRecord
  STATUS = %w(pending paid complete cancelled)
  belongs_to :product
  belongs_to :order

  def price
    return self.product.price * self.quantity
  end

  def self.find_order_items(merchant)
    order_item_list = []
    OrderItem.all.each do |order|
      product = order.product
      order_item_list << order unless product.merchant_id != merchant.id
    end
    return order_item_list
  end
end
