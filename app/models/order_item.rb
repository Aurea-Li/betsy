class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  def price
    return self.product.price * self.quantity
  end
end
