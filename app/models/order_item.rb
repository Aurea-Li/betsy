class OrderItem < ApplicationRecord
  STATUS = %w(pending paid complete cancelled)
  belongs_to :product
  belongs_to :order

  validates :quantity, presence: true, numericality: { greater_than: 0 }

  validates :status,  presence: true,
  inclusion: { in: STATUS }

  def price
    return self.product.price * self.quantity
  end
end
