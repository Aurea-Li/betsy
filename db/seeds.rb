require 'csv'


merchant_file = Rails.root.join('db', 'merchant_seeds.csv')
order_item_file = Rails.root.join('db', 'order_item_seeds.csv')
order_file = Rails.root.join('db', 'order_seeds.csv')
product_file = Rails.root.join('db', 'product_seeds.csv')

CSV.foreach(merchant_file, headers: true, header_converters: :symbol, converters: :all) do |row|
  data = Hash[row.headers.zip(row.fields)]
  puts data
  Merchant.create!(data)
end

CSV.foreach(order_file, headers: true, header_converters: :symbol, converters: :all) do |row|
  data = Hash[row.headers.zip(row.fields)]
  puts data
  Order.create!(data)
end

CSV.foreach(product_file, headers: true, header_converters: :symbol, converters: :all) do |row|
  data = Hash[row.headers.zip(row.fields)]
  puts data
  merchant = Merchant.all.shuffle.first
  product = Product.new(data)
  product.update_attributes(merchant: merchant)
  product.save!
end

CSV.foreach(order_item_file, headers: true, header_converters: :symbol, converters: :all) do |row|
  data = Hash[row.headers.zip(row.fields)]
  puts data
  product = Product.all.shuffle.first
  order = Order.all.shuffle.first
  orderitem = OrderItem.new(data)
  orderitem.update_attributes(order: order, product: product)
  orderitem.save!
end
