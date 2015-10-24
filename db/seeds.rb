# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Spree::Core::Engine.load_seed if defined?(Spree::Core)
Spree::Auth::Engine.load_seed if defined?(Spree::Auth)
Alchemy::Seeder.seed!

10.times do

  v = Spree::Vendor.create(name: Faker::Company.name, order_cutoff_time: '5PM')

  Spree::User.create(email: Faker::Internet.email, firstname: Faker::Name.first_name,
    lastname: Faker::Name.last_name, vendor_id: v.id)

  10.times do

    prod = Spree::Product.create(name: Faker::Food.ingredient, price: rand(2.0...100.0),
      shipping_category_id: 2, vendor_id: v.id)
		prod.available_on=DateTime.yesterday
    variant = Spree::Variant.last
    variant.is_master = true
    variant.product_id = prod.id
    variant.sku = rand(1000000000..9999999999)
    variant.stock_items_count = 1000
    variant.save
  end

end

variants = Spree::Variant.all.select {|variant| variant.stock_items_count == 1000 }

10.times do
  c = Spree::Customer.create(name: Faker::Company.name, account_id: rand(1000..9999))

  Spree::User.create(email: Faker::Internet.email, firstname: Faker::Name.first_name,
    lastname: Faker::Name.last_name, customer_id: c.id)
end

50.times do
  order = Spree::Order.create(customer_id: Spree::Customer.all.sample.id, vendor_id: Spree::Vendor.all.sample.id)

  5.times do
    Spree::LineItem.create(order_id: order.id, variant_id: Spree::Variant.all.sample.id) #, quantity: rand(1..10))
  end
end
