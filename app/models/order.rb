class Order < ApplicationRecord
  STATUS = %w(paid fulfilled)
  has_many :order_items


  def price
    return self.order_items.sum { |item| item.price}
  end
end
