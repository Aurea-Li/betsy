class Order < ApplicationRecord
  STATUS = %w(paid fulfilled)
  has_many :order_items


end
