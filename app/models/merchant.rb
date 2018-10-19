class Merchant < ApplicationRecord
  has_many :products

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
end
