class Product < ApplicationRecord
  belongs_to :merchant

  has_many :reviews
  has_many :order_items

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :active, presence: true, inclusion: [true, false]
  validates :category, presence: true

  # AYL: do we need a rating attribute if we define it in a function?
  def rating
    unless self.reviews.empty?
      return 1.0 * self.reviews.sum{ |review| review.rating } / self.reviews.length
    end
    return "No ratings"
  end
end
