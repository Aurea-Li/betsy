require 'faker'
require 'date'
require 'csv'

# Merchant seed script
CSV.open('db/merchant_seeds.csv', "w", :write_headers=> true,
  :headers => ["username", "email", "uid", "provider"]) do |csv|

  25.times do
    username = Faker::HarryPotter.character
    email = Faker::Internet.email
    uid = Faker::Number.number(3)
    provider = "github"

    csv << [username, email, uid, provider]
  end
end
