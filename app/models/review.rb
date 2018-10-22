class Review < ApplicationRecord
  RATINGS = [*1..5]
  belongs_to :product
end
