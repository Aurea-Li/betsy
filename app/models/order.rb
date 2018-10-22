class Order < ApplicationRecord
  STATUS = %w(pending paid complete cancelled)
  has_many :order_items

  validates :status,  presence: true,
  inclusion: { in: STATUS }

  validates :name, presence: true, if: :is_not_pending
  validates :email, presence: true, if: :is_not_pending
  validates :address, presence: true, if: :is_not_pending
  validates :cc_num, presence: true, if: :is_not_pending
  validates :cc_cvv, presence: true, if: :is_not_pending
  validates :cc_expiration, presence: true, if: :is_not_pending


  def is_not_pending
    return self.status != 'pending'
  end

  def price
    return self.order_items.sum { |item| item.price}
  end

  def CC_num_last_four
    return self.cc_num.to_s[-4..-1]
  end

  def total_quantity
    return self.order_items.sum {|item| item.quantity }
  end

  def paid
    self.status = 'paid'

    self.order_items.each do |item|
      item.status = 'paid'
    end
  end
end
