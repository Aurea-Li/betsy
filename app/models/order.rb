class Order < ApplicationRecord
  STATUS = %w(pending paid)
  has_many :order_items

  
end
