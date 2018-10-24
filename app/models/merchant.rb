class Merchant < ApplicationRecord
  has_many :products
  has_many :order_items, through: :products

  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true

  def self.create_from_github(auth_hash)
    merchant = Merchant.new
    merchant.username = auth_hash['info']['nickname']
    merchant.email = auth_hash['info']['email']
    merchant.uid = auth_hash['uid']
    merchant.provider = 'github'

    return merchant
  end

  def paid_order_items
    return self.order_items.where(status: 'paid')
  end

  def pending_order_items
    return self.order_items.where(status: 'pending')
  end

  def cancelled_order_items
    return self.order_items.where(status: 'cancelled')
  end

  def complete_order_items
    return self.order_items.where(status: 'complete')
  end

  def rating


    products_with_reviews = self.products.find_all{ |product| product.rating }

    if products_with_reviews.empty?
      return nil
    else
      return 1.0 * products_with_reviews.sum{ |product| product.rating } / products_with_reviews.length
    end

  end
end
