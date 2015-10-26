# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Spree::Core::Engine.load_seed if defined?(Spree::Core)
Spree::Auth::Engine.load_seed if defined?(Spree::Auth)

admin = Spree::Role.create(name: 'admin')
vendor = Spree::Role.create(name: 'vendor')
customer = Spree::Role.create(name: 'customer')


##############################################################################
# Create users
##############################################################################
u1 = Spree::User.create(email: 'john@doughdonuts.com', firstname: 'John', lastname: Faker::Name.last_name, phone: Faker::PhoneNumber.phone_number, vendor_id: 1, password: 'password')
u1.spree_roles << vendor
u1.save!
u2 = Spree::User.create(email: 'mark@cecicela.com', firstname: 'Mark', lastname: Faker::Name.last_name, phone: Faker::PhoneNumber.phone_number, vendor_id: 2, password: 'password')
u2.spree_roles << vendor
u2.save!
u3 = Spree::User.create(email: 'celine@canele.com', firstname: 'Celine', lastname: Faker::Name.last_name, phone: Faker::PhoneNumber.phone_number, vendor_id: 3, password: 'password')
u3.spree_roles << vendor
u3.save!
u4 = Spree::User.create(email: 'mary@chikalicious.com', firstname: 'Mary', lastname: Faker::Name.last_name, phone: Faker::PhoneNumber.phone_number, vendor_id: 4, password: 'password')
u4.spree_roles << vendor
u4.save!
u5 = Spree::User.create(email: 'bill@billysbakery.com', firstname: 'Bill', lastname: Faker::Name.last_name, phone: Faker::PhoneNumber.phone_number, vendor_id: 5, password: 'password')
u5.spree_roles << vendor
u5.save!

u6 = Spree::User.create(email: 'amy@creeksidecafe.com', firstname: 'Amy', lastname: Faker::Name.last_name, phone: Faker::PhoneNumber.phone_number, customer_id: 1, password: 'password')
u6.spree_roles << customer
u6.save!
u7 = Spree::User.create(email: 'michael@whotel.com', firstname: 'Michael', lastname: Faker::Name.last_name, phone: Faker::PhoneNumber.phone_number, customer_id: 2, password: 'password')
u7.spree_roles << customer
u7.save!
u8 = Spree::User.create(email: 'kat@frenchcafe.com', firstname: 'Kathleen', lastname: Faker::Name.last_name, phone: Faker::PhoneNumber.phone_number, customer_id: 3, password: 'password')
u8.spree_roles << customer
u8.save!
u9 = Spree::User.create(email: 'myles@murrays.com', firstname: 'Myles', lastname: Faker::Name.last_name, phone: Faker::PhoneNumber.phone_number, customer_id: 4, password: 'password')
u9.spree_roles << customer
u9.save!
u10 = Spree::User.create(email: 'pete@knickerbocker.com', firstname: 'Pete', lastname: Faker::Name.last_name, phone: Faker::PhoneNumber.phone_number, customer_id: 5, password: 'password')
u10.spree_roles << customer
u10.save!

v1 = Spree::Vendor.create(name: 'Dough Donuts', order_cutoff_time: '5PM', delivery_minimum: 10.0, payment_terms: 30)
v2 = Spree::Vendor.create(name: 'Ceci Cela', order_cutoff_time: '6PM', delivery_minimum: 10.0, payment_terms: 30)
v3 = Spree::Vendor.create(name: 'Canele by Celine', order_cutoff_time: '8PM', delivery_minimum: 10.0, payment_terms: 0)
v4 = Spree::Vendor.create(name: "Chikalicious", order_cutoff_time: '9PM', delivery_minimum: 10.0, payment_terms: 15)
v5 = Spree::Vendor.create(name: "Billy's Bakery", order_cutoff_time: '5PM', delivery_minimum: 10.0, payment_terms: 45)

c6 = Spree::Customer.create(name: "Creek Side Cafe", account_id: 47584, email: "contact@creeksidecafe.com")
c7 = Spree::Customer.create(name: "W Hotel", account_id: 85893, email: "contact@whotel.com")
c8 = Spree::Customer.create(name: "French Cafe", account_id: 57203, email: "contact@frenchcafe.com")
c9 = Spree::Customer.create(name: "Murray's", account_id: 60593, email: "contact@murrays.com")
c10 = Spree::Customer.create(name: "Knickerbocker Club", account_id: 29493, email: "contact@knickerbocker.com")

c6.build_ship_address(firstname: u6.firstname, lastname: u6.lastname, address1: Faker::Address.street_address, city: 'New York', zipcode: '10005', phone: u6.phone,
  state_name: 'New York', company: c6.name, country_id: 232)
c7.build_ship_address(firstname: u6.firstname, lastname: u7.lastname, address1: Faker::Address.street_address, city: 'New York', zipcode: '10005', phone: u7.phone,
  state_name: 'New York', company: c6.name, country_id: 232)
c8.build_ship_address(firstname: u6.firstname, lastname: u8.lastname, address1: Faker::Address.street_address, city: 'New York', zipcode: '10005', phone: u8.phone,
  state_name: 'New York', company: c6.name, country_id: 232)
c9.build_ship_address(firstname: u6.firstname, lastname: u9.lastname, address1: Faker::Address.street_address, city: 'New York', zipcode: '10005', phone: u9.phone,
  state_name: 'New York', company: c6.name, country_id: 232)
c10.build_ship_address(firstname: u6.firstname, lastname: u10.lastname, address1: Faker::Address.street_address, city: 'New York', zipcode: '10005', phone: u10.phone,
  state_name: 'New York', company: c6.name, country_id: 232)

c6.vendors += [v1, v2, v3, v4, v5]
c7.vendors += [v1, v2, v3, v4, v5]
c8.vendors += [v1, v2, v3, v4, v5]
c9.vendors += [v1, v2, v3, v4, v5]
c10.vendors += [v1, v2, v3, v4, v5]

c6.save!
c7.save!
c8.save!
c9.save!
c10.save!

Spree::ShippingCategory.create(name: "Standard")
Spree::ShippingCategory.create(name: "Over Size")

Spree::TaxCategory.create(name: "Food", is_default: false)

sl1 = Spree::StockLocation.create(name: v1.name, backorderable_default: true)
sl2 = Spree::StockLocation.create(name: v2.name, backorderable_default: true)
sl3 = Spree::StockLocation.create(name: v3.name, backorderable_default: true)
sl4 = Spree::StockLocation.create(name: v4.name, backorderable_default: true)
sl5 = Spree::StockLocation.create(name: v5.name, backorderable_default: true)

available_date = DateTime.new(2013, 1, 1)

###############################################################################
# Vendor 1 - Dough Donuts :Products, Variants, Orders > Li
###############################################################################
p1 = v1.products.create(name: "Cafe Au Lait", price: 3.00, shipping_category_id: 1, available_on: available_date,
  description: "One of Dough's most popular flavors. A blend of fresh roasted coffee beans and pecan brown sugar tops our signature glaze.")
p2 = v1.products.create(name: "Chocolate with Cocoa Nibbs", price: 3.00, shipping_category_id: 1, available_on: available_date,
  description: "This rich delicacy celebrates classic pastries using chocolate fondant and finished with decadent hand shaven cocoa nibs.")
p3 = v1.products.create(name: "Chocolate Salted Caramel", price: 3.00, shipping_category_id: 1, available_on: available_date,
  description: "Belgium dark chocolate infused with French caramel and sprinkled with Mediterranean sea-salt.")
p4 = v1.products.create(name: "Cinnamon Sugar", price: 3.00, shipping_category_id: 1, available_on: available_date,
  description: "Using the best cinnamon Mexico has to offer, this flavor is sure to warm your taste buds.")
p5 = v1.products.create(name: "Mocha Almond Crunch", price: 3.00, shipping_category_id: 1, available_on: available_date,
  description: "")
p6 = v1.products.create(name: "Glazed", price: 3.00, shipping_category_id: 1, available_on: available_date,
  description: "'The Original' simply a best seller. Dough uses a signature glaze with it's perfect balance of sweetness over our oversized soft dough that make this a classic.")
p7 = v1.products.create(name: "Dulce de Leche", price: 3.00, shipping_category_id: 1, available_on: available_date,
  description: "Spanish for 'candy of milk', this rich and creamy luxurious glaze is topped with a delicate toasted almond crunch.")
p8 = v1.products.create(name: "Hibiscus", price: 3.00, shipping_category_id: 1, available_on: available_date,
  description: "A sweet and tangy glaze transforms the subtle floral flavors of imported Mexican hibiscus into our most unique creation.")
p9 = v1.products.create(name: "Lemon Poppy", price: 3.00, shipping_category_id: 1, available_on: available_date,
  description: "A glaze of sweet and fresh lemon juice is topped with Turkish poppy seeds and light lemon zest.")
p10 = v1.products.create(name: "Filled Nutella", price: 3.50, shipping_category_id: 1, available_on: available_date,
  description: "Delectable Nutella filled doughnut.")

var1 = p1.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var2 = p2.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var3 = p3.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var4 = p4.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var5 = p5.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var6 = p6.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var7 = p7.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var8 = p8.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var9 = p9.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var10 = p10.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)

var1.stock_items.create(stock_location_id: sl1.id)
var2.stock_items.create(stock_location_id: sl1.id)
var3.stock_items.create(stock_location_id: sl1.id)
var4.stock_items.create(stock_location_id: sl1.id)
var5.stock_items.create(stock_location_id: sl1.id)
var6.stock_items.create(stock_location_id: sl1.id)
var7.stock_items.create(stock_location_id: sl1.id)
var8.stock_items.create(stock_location_id: sl1.id)
var9.stock_items.create(stock_location_id: sl1.id)
var10.stock_items.create(stock_location_id: sl1.id)


12.times do |mo|
  o1 = v1.orders.create(customer_id: c6.id, ship_address_id: c6.ship_address_id, bill_address_id: c6.ship_address_id, email: c6.email,
    delivery_date: DateTime.new(2015, mo + 1, 28))
  o1.line_items.create(variant_id: var1.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var2.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var3.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var4.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var5.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var6.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var7.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var8.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var9.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var10.id, quantity: rand(4..100))

  item_count = 0
  item_total = 0
  o1.line_items.each do |item|
    item_count += item.quantity
    item_total += (item.quantity * item.price)
  end
  o1.item_count = item_count
  o1.item_total = item_total
  o1.total = item_total
  o1.save
end

12.times do |mo|
  o1 = v1.orders.create(customer_id: c7.id, ship_address_id: c7.ship_address_id, bill_address_id: c7.ship_address_id, email: c7.email,
    delivery_date: DateTime.new(2015, mo + 1, 15))

  o1.line_items.create(variant_id: var3.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var4.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var5.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var6.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var7.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var8.id, quantity: rand(4..100))

  item_count = 0
  item_total = 0
  o1.line_items.each do |item|
    item_count += item.quantity
    item_total += (item.quantity * item.price)
  end
  o1.item_count = item_count
  o1.item_total = item_total
  o1.total = item_total
  o1.save
end

12.times do |mo|
  o1 = v1.orders.create(customer_id: c8.id, ship_address_id: c8.ship_address_id, bill_address_id: c8.ship_address_id, email: c8.email,
    delivery_date: DateTime.new(2015, mo + 1, 28))
  o1.line_items.create(variant_id: var1.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var2.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var3.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var4.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var5.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var6.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var7.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var8.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var9.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var10.id, quantity: rand(4..100))

  item_count = 0
  item_total = 0
  o1.line_items.each do |item|
    item_count += item.quantity
    item_total += (item.quantity * item.price)
  end
  o1.item_count = item_count
  o1.item_total = item_total
  o1.total = item_total
  o1.save
end

12.times do |mo|
  o1 = v1.orders.create(customer_id: c9.id, ship_address_id: c9.ship_address_id, bill_address_id: c9.ship_address_id, email: c9.email,
    delivery_date: DateTime.new(2015, mo + 1, 28))
  o1.line_items.create(variant_id: var1.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var2.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var3.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var4.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var5.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var6.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var7.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var8.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var9.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var10.id, quantity: rand(4..100))

  item_count = 0
  item_total = 0
  o1.line_items.each do |item|
    item_count += item.quantity
    item_total += (item.quantity * item.price)
  end
  o1.item_count = item_count
  o1.item_total = item_total
  o1.total = item_total
  o1.save
end

12.times do |mo|
  o1 = v1.orders.create(customer_id: c10.id, ship_address_id: c10.ship_address_id, bill_address_id: c10.ship_address_id, email: c10.email,
    delivery_date: DateTime.new(2015, mo + 1, 28))
  o1.line_items.create(variant_id: var1.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var2.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var3.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var4.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var5.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var6.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var7.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var8.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var9.id, quantity: rand(4..100))
  o1.line_items.create(variant_id: var10.id, quantity: rand(4..100))

  item_count = 0
  item_total = 0
  o1.line_items.each do |item|
    item_count += item.quantity
    item_total += (item.quantity * item.price)
  end
  o1.item_count = item_count
  o1.item_total = item_total
  o1.total = item_total
  o1.save
end

###############################################################################
# Vendor 2 - Ceci Cela :Products, Variants, Orders > Li
###############################################################################
p1 = v2.products.create(name: "Apple Tart", price: 26.00, shipping_category_id: 1, available_on: available_date,
  description: "")
p2 = v2.products.create(name: "Pear Tart", price: 26.00, shipping_category_id: 1, available_on: available_date,
  description: "")
p3 = v2.products.create(name: "Lemon Tart", price: 26.00, shipping_category_id: 1, available_on: available_date,
  description: "Delicious rich and refreshing lemon tart")
p4 = v2.products.create(name: "Fruit Tart", price: 35.00, shipping_category_id: 1, available_on: available_date,
  description: "Sugar crust covered with chocolate, pastry cream, fresh fruit")
p5 = v2.products.create(name: "Paradise Cake", price: 36.00, shipping_category_id: 1, available_on: available_date,
  description: "Mix of guava, mango, passion fruit mousse with fresh fruit on top")
p6 = v2.products.create(name: "Chocolate Cake", price: 33.00, shipping_category_id: 1, available_on: available_date,
  description: "Layers of chocolate cake and mousse")
p7 = v2.products.create(name: "Black Forest Cake", price: 36.00, shipping_category_id: 1, available_on: available_date,
  description: "Chocolate cake with vanilla cream and brandied cherries")
p8 = v2.products.create(name: "Pear William Cake", price: 36.00, shipping_category_id: 1, available_on: available_date,
  description: "Vanilla cake with sliced pears")
p9 = v2.products.create(name: "Strawberry Charlotte", price: 36.00, shipping_category_id: 1, available_on: available_date,
  description: "Strawberry mousse surrounded by ladyfingers")
p10 = v2.products.create(name: "Tiramisu", price: 36.00, shipping_category_id: 1, available_on: available_date,
  description: "Mascarpone cheese mousse, espresso sponged ladyfingers, marcalas liquor surrounded by ladyfingers")

var1 = p1.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var2 = p2.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var3 = p3.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var4 = p4.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var5 = p5.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var6 = p6.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var7 = p7.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var8 = p8.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var9 = p9.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var10 = p10.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)

var1.stock_items.create(stock_location_id: sl2.id)
var2.stock_items.create(stock_location_id: sl2.id)
var3.stock_items.create(stock_location_id: sl2.id)
var4.stock_items.create(stock_location_id: sl2.id)
var5.stock_items.create(stock_location_id: sl2.id)
var6.stock_items.create(stock_location_id: sl2.id)
var7.stock_items.create(stock_location_id: sl2.id)
var8.stock_items.create(stock_location_id: sl2.id)
var9.stock_items.create(stock_location_id: sl2.id)
var10.stock_items.create(stock_location_id: sl2.id)


12.times do |mo|
  o1 = v2.orders.create(customer_id: c6.id, ship_address_id: c6.ship_address_id, bill_address_id: c6.ship_address_id, email: c6.email,
    delivery_date: DateTime.new(2015, mo + 1, 28))
  o1.line_items.create(variant_id: var1.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var2.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var3.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var4.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var5.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var6.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var7.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var8.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var9.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var10.id, quantity: rand(1..5))

  item_count = 0
  item_total = 0
  o1.line_items.each do |item|
    item_count += item.quantity
    item_total += (item.quantity * item.price)
  end
  o1.item_count = item_count
  o1.item_total = item_total
  o1.total = item_total
  o1.save
end

12.times do |mo|
  o1 = v2.orders.create(customer_id: c7.id, ship_address_id: c7.ship_address_id, bill_address_id: c7.ship_address_id, email: c7.email,
    delivery_date: DateTime.new(2015, mo + 1, 15))

  o1.line_items.create(variant_id: var3.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var4.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var5.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var6.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var7.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var8.id, quantity: rand(1..5))

  item_count = 0
  item_total = 0
  o1.line_items.each do |item|
    item_count += item.quantity
    item_total += (item.quantity * item.price)
  end
  o1.item_count = item_count
  o1.item_total = item_total
  o1.total = item_total
  o1.save
end

12.times do |mo|
  o1 = v2.orders.create(customer_id: c8.id, ship_address_id: c8.ship_address_id, bill_address_id: c8.ship_address_id, email: c8.email,
    delivery_date: DateTime.new(2015, mo + 1, 28))
  o1.line_items.create(variant_id: var1.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var2.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var3.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var4.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var5.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var6.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var7.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var8.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var9.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var10.id, quantity: rand(1..5))

  item_count = 0
  item_total = 0
  o1.line_items.each do |item|
    item_count += item.quantity
    item_total += (item.quantity * item.price)
  end
  o1.item_count = item_count
  o1.item_total = item_total
  o1.total = item_total
  o1.save
end

12.times do |mo|
  o1 = v2.orders.create(customer_id: c9.id, ship_address_id: c9.ship_address_id, bill_address_id: c9.ship_address_id, email: c9.email,
    delivery_date: DateTime.new(2015, mo + 1, 28))
  o1.line_items.create(variant_id: var1.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var2.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var3.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var4.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var5.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var6.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var7.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var8.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var9.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var10.id, quantity: rand(1..5))

  item_count = 0
  item_total = 0
  o1.line_items.each do |item|
    item_count += item.quantity
    item_total += (item.quantity * item.price)
  end
  o1.item_count = item_count
  o1.item_total = item_total
  o1.total = item_total
  o1.save
end

12.times do |mo|
  o1 = v2.orders.create(customer_id: c10.id, ship_address_id: c10.ship_address_id, bill_address_id: c10.ship_address_id, email: c10.email,
    delivery_date: DateTime.new(2015, mo + 1, 28))
  o1.line_items.create(variant_id: var1.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var2.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var3.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var4.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var5.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var6.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var7.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var8.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var9.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var10.id, quantity: rand(1..5))

  item_count = 0
  item_total = 0
  o1.line_items.each do |item|
    item_count += item.quantity
    item_total += (item.quantity * item.price)
  end
  o1.item_count = item_count
  o1.item_total = item_total
  o1.total = item_total
  o1.save
end
###############################################################################
# Vendor 3 - Canele by Celine :Products, Variants, Orders > Li
###############################################################################
p1 = v3.products.create(name: "Sweet Canele (Selection of 3)", price: 4.90, shipping_category_id: 1, available_on: available_date,
  description: "A bag of 3 mini canelés. A petite pastry which has a caramelized crust which protects a moist and tender heart, like a crème brûlèe. Let the bakery know which flavors you want by leaving a note in the comment box below. Select from: Caramel, Cinnamon, Dark Chocolate, Gingerbread, Hazelnut (Contains nuts), Lemon, Lime, Mint Choco, Nougat (Contains nuts), Orange, Orange Blossom, Pink Praline (Contains nuts), Pistachio (Contains nuts), Raspberry, Rose Water, Rum, Vanilla.")
p2 = v3.products.create(name: "Savory Canele (Selection of 3)", price: 5.90, shipping_category_id: 1, available_on: available_date,
  description: "A bag of 3 mini canelés. A petite pastry which has a caramelized crust which protects a moist and tender heart, like a crème brûlée. If you would like a selection of flavors, let the bakery know which flavors you want by leaving a note in the comment box below.")
p3 = v3.products.create(name: "Mini Glass Bell Jar (With 3 Mini Caneles)", price: 15.00, shipping_category_id: 1, available_on: available_date,
  description: "3 mini caneles in the flavor of you choice, displayed in a glass jar. Select your flavor and let the bakery know your choice in the comments box. Sweet flavors to choose from: Caramel, Dark Chocolate, Gingerbread, Lemon, Lime, Mint Choco, Orange, Orange Blossom, Pink Praline (Contains nuts), Pistachio (Contains nuts), Raspberry, Rose Water, Rum, Vanilla, (Seasonal flavors: Hazelnut (Contains nuts), Nougat (Contains nuts), Cinnamon). Savory Flavors to choose from: Black Olive, Cheese, Chorizo, Pesto, Truffle.")
p4 = v3.products.create(name: "Box of 9 Mini Caneles", price: 19.80, shipping_category_id: 1, available_on: available_date,
  description: "A selection of 9 canelés of your choice, select either sweet or savory canelés. Select your flavors and let the bakery know your choice in the comments box. Sweet flavors to choose from: Caramel, Dark Chocolate, Gingerbread, Lemon, Lime, Mint Choco, Orange, Orange Blossom, Pink Praline (Contains nuts), Pistachio (Contains nuts), Raspberry, Rose Water, Rum, Vanilla, (Seasonal flavors: Hazelnut (Contains nuts), Nougat (Contains nuts), Cinnamon). Savory Flavors to choose from: Black Olive, Cheese, Chorizo, Pesto, Truffle.")
p5 = v3.products.create(name: "Large Canele (Selection of 6)", price: 21.00, shipping_category_id: 1, available_on: available_date,
  description: "A selection of 6 canelés of your choice. If you would like a selection, let the bakery know your choice of flavors in the comments box.")


var1 = p1.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var2 = p2.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var3 = p3.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var4 = p4.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var5 = p5.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)


var1.stock_items.create(stock_location_id: sl3.id)
var2.stock_items.create(stock_location_id: sl3.id)
var3.stock_items.create(stock_location_id: sl3.id)
var4.stock_items.create(stock_location_id: sl3.id)
var5.stock_items.create(stock_location_id: sl3.id)

12.times do |mo|
  o1 = v3.orders.create(customer_id: c6.id, ship_address_id: c6.ship_address_id, bill_address_id: c6.ship_address_id, email: c6.email,
    delivery_date: DateTime.new(2015, mo + 1, 15))

  o1.line_items.create(variant_id: var1.id, quantity: rand(1..100))
  o1.line_items.create(variant_id: var2.id, quantity: rand(1..100))
  o1.line_items.create(variant_id: var3.id, quantity: rand(1..100))
  o1.line_items.create(variant_id: var4.id, quantity: rand(1..100))
  o1.line_items.create(variant_id: var5.id, quantity: rand(1..100))

  item_count = 0
  item_total = 0
  o1.line_items.each do |item|
    item_count += item.quantity
    item_total += (item.quantity * item.price)
  end
  o1.item_count = item_count
  o1.item_total = item_total
  o1.total = item_total
  o1.save
end

12.times do |mo|
  o1 = v3.orders.create(customer_id: c7.id, ship_address_id: c7.ship_address_id, bill_address_id: c7.ship_address_id, email: c7.email,
    delivery_date: DateTime.new(2015, mo + 1, 15))

  o1.line_items.create(variant_id: var1.id, quantity: rand(1..100))
  o1.line_items.create(variant_id: var2.id, quantity: rand(1..100))
  o1.line_items.create(variant_id: var3.id, quantity: rand(1..100))
  o1.line_items.create(variant_id: var4.id, quantity: rand(1..100))
  o1.line_items.create(variant_id: var5.id, quantity: rand(1..100))

  item_count = 0
  item_total = 0
  o1.line_items.each do |item|
    item_count += item.quantity
    item_total += (item.quantity * item.price)
  end
  o1.item_count = item_count
  o1.item_total = item_total
  o1.total = item_total
  o1.save
end

12.times do |mo|
  o1 = v3.orders.create(customer_id: c8.id, ship_address_id: c8.ship_address_id, bill_address_id: c8.ship_address_id, email: c8.email,
    delivery_date: DateTime.new(2015, mo + 1, 15))

  o1.line_items.create(variant_id: var1.id, quantity: rand(1..100))
  o1.line_items.create(variant_id: var2.id, quantity: rand(1..100))
  o1.line_items.create(variant_id: var3.id, quantity: rand(1..100))
  o1.line_items.create(variant_id: var4.id, quantity: rand(1..100))
  o1.line_items.create(variant_id: var5.id, quantity: rand(1..100))

  item_count = 0
  item_total = 0
  o1.line_items.each do |item|
    item_count += item.quantity
    item_total += (item.quantity * item.price)
  end
  o1.item_count = item_count
  o1.item_total = item_total
  o1.total = item_total
  o1.save
end

12.times do |mo|
  o1 = v3.orders.create(customer_id: c9.id, ship_address_id: c9.ship_address_id, bill_address_id: c9.ship_address_id, email: c9.email,
    delivery_date: DateTime.new(2015, mo + 1, 28))
  o1.line_items.create(variant_id: var1.id, quantity: rand(1..100))
  o1.line_items.create(variant_id: var2.id, quantity: rand(1..100))
  o1.line_items.create(variant_id: var3.id, quantity: rand(1..100))
  o1.line_items.create(variant_id: var4.id, quantity: rand(1..100))
  o1.line_items.create(variant_id: var5.id, quantity: rand(1..100))

  item_count = 0
  item_total = 0
  o1.line_items.each do |item|
    item_count += item.quantity
    item_total += (item.quantity * item.price)
  end
  o1.item_count = item_count
  o1.item_total = item_total
  o1.total = item_total
  o1.save

end

12.times do |mo|
  o1 = v3.orders.create(customer_id: c10.id, ship_address_id: c10.ship_address_id, bill_address_id: c10.ship_address_id, email: c10.email,
    delivery_date: DateTime.new(2015, mo + 1, 15))

  o1.line_items.create(variant_id: var1.id, quantity: rand(1..100))
  o1.line_items.create(variant_id: var2.id, quantity: rand(1..100))
  o1.line_items.create(variant_id: var3.id, quantity: rand(1..100))
  o1.line_items.create(variant_id: var4.id, quantity: rand(1..100))
  o1.line_items.create(variant_id: var5.id, quantity: rand(1..100))

  item_count = 0
  item_total = 0
  o1.line_items.each do |item|
    item_count += item.quantity
    item_total += (item.quantity * item.price)
  end
  o1.item_count = item_count
  o1.item_total = item_total
  o1.total = item_total
  o1.save
end

###############################################################################
# Vendor 4 - Chikalicious :Products, Variants, Orders > Li
###############################################################################
p1 = v4.products.create(name: "Jackson Pollock Salted Caramel Macaroon", price: 2.50, shipping_category_id: 1, available_on: available_date,
  description: "The coolest looking and most delicious macaron in the East Village!")
p2 = v4.products.create(name: "Cookies", price: 4.00, shipping_category_id: 1, available_on: available_date,
  description: "Some of the best cookies in Manhattan!")
p3 = v4.products.create(name: "Vanilla Crepe Cake", price: 59.95, shipping_category_id: 1, available_on: available_date,
  description: "Layers of thin crepes with a vanilla mousse")
p4 = v4.products.create(name: "Green tea Crepe Cake", price: 59.95, shipping_category_id: 1, available_on: available_date,
  description: "Layers of thin crepes with a green tea mousse")
p5 = v4.products.create(name: "Puff Chika Creme Puff", price: 2.95, shipping_category_id: 1, available_on: available_date,
  description: "Stunning cream puff")
p6 = v4.products.create(name: "Cookie Eclair", price: 5.50, shipping_category_id: 1, available_on: available_date,
  description: "An eclair, but crunchy with a delectable creamy filling")
p7 = v4.products.create(name: "Dough'ssant", price: 5.00, shipping_category_id: 1, available_on: available_date,
  description: "Is this the original croissant-doughnut hybrid? It is most certainly worth trying all the flavors!")


var1 = p1.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var2 = p2.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var3 = p3.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var4 = p4.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var5 = p5.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var6 = p6.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var7 = p7.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)

var1.stock_items.create(stock_location_id: sl4.id)
var2.stock_items.create(stock_location_id: sl4.id)
var3.stock_items.create(stock_location_id: sl4.id)
var4.stock_items.create(stock_location_id: sl4.id)
var5.stock_items.create(stock_location_id: sl4.id)
var6.stock_items.create(stock_location_id: sl4.id)
var7.stock_items.create(stock_location_id: sl4.id)

12.times do |mo|
  o1 = v4.orders.create(customer_id: c6.id, ship_address_id: c6.ship_address_id, bill_address_id: c6.ship_address_id, email: c6.email,
    delivery_date: DateTime.new(2015, mo + 1, 28))

  o1.line_items.create(variant_id: var1.id, quantity: rand(12..100))
  o1.line_items.create(variant_id: var2.id, quantity: rand(12..100))
  o1.line_items.create(variant_id: var3.id, quantity: rand(1..10))
  o1.line_items.create(variant_id: var4.id, quantity: rand(1..10))
  o1.line_items.create(variant_id: var5.id, quantity: rand(12..100))
  o1.line_items.create(variant_id: var6.id, quantity: rand(12..100))
  o1.line_items.create(variant_id: var7.id, quantity: rand(12..100))
  o1.line_items.create(variant_id: var8.id, quantity: rand(12..100))

  item_count = 0
  item_total = 0
  o1.line_items.each do |item|
    item_count += item.quantity
    item_total += (item.quantity * item.price)
  end
  o1.item_count = item_count
  o1.item_total = item_total
  o1.total = item_total
  o1.save
end

12.times do |mo|
  o1 = v4.orders.create(customer_id: c7.id, ship_address_id: c7.ship_address_id, bill_address_id: c7.ship_address_id, email: c7.email,
    delivery_date: DateTime.new(2015, mo + 1, 28))

  o1.line_items.create(variant_id: var1.id, quantity: rand(12..100))
  o1.line_items.create(variant_id: var2.id, quantity: rand(12..100))
  o1.line_items.create(variant_id: var3.id, quantity: rand(1..10))
  o1.line_items.create(variant_id: var4.id, quantity: rand(1..10))
  o1.line_items.create(variant_id: var5.id, quantity: rand(12..100))
  o1.line_items.create(variant_id: var6.id, quantity: rand(12..100))
  o1.line_items.create(variant_id: var7.id, quantity: rand(12..100))
  o1.line_items.create(variant_id: var8.id, quantity: rand(12..100))

  item_count = 0
  item_total = 0
  o1.line_items.each do |item|
    item_count += item.quantity
    item_total += (item.quantity * item.price)
  end
  o1.item_count = item_count
  o1.item_total = item_total
  o1.total = item_total
  o1.save
end

12.times do |mo|
  o1 = v4.orders.create(customer_id: c8.id, ship_address_id: c8.ship_address_id, bill_address_id: c8.ship_address_id, email: c8.email,
    delivery_date: DateTime.new(2015, mo + 1, 28))

  o1.line_items.create(variant_id: var1.id, quantity: rand(12..100))
  o1.line_items.create(variant_id: var2.id, quantity: rand(12..100))
  o1.line_items.create(variant_id: var3.id, quantity: rand(1..10))
  o1.line_items.create(variant_id: var4.id, quantity: rand(1..10))
  o1.line_items.create(variant_id: var5.id, quantity: rand(12..100))
  o1.line_items.create(variant_id: var6.id, quantity: rand(12..100))
  o1.line_items.create(variant_id: var7.id, quantity: rand(12..100))
  o1.line_items.create(variant_id: var8.id, quantity: rand(12..100))

  item_count = 0
  item_total = 0
  o1.line_items.each do |item|
    item_count += item.quantity
    item_total += (item.quantity * item.price)
  end
  o1.item_count = item_count
  o1.item_total = item_total
  o1.total = item_total
  o1.save
end

12.times do |mo|
  o1 = v4.orders.create(customer_id: c9.id, ship_address_id: c9.ship_address_id, bill_address_id: c9.ship_address_id, email: c9.email,
    delivery_date: DateTime.new(2015, mo + 1, 28))

  o1.line_items.create(variant_id: var1.id, quantity: rand(12..100))
  o1.line_items.create(variant_id: var2.id, quantity: rand(12..100))
  o1.line_items.create(variant_id: var3.id, quantity: rand(1..10))
  o1.line_items.create(variant_id: var4.id, quantity: rand(1..10))
  o1.line_items.create(variant_id: var5.id, quantity: rand(12..100))
  o1.line_items.create(variant_id: var6.id, quantity: rand(12..100))
  o1.line_items.create(variant_id: var7.id, quantity: rand(12..100))
  o1.line_items.create(variant_id: var8.id, quantity: rand(12..100))

  item_count = 0
  item_total = 0
  o1.line_items.each do |item|
    item_count += item.quantity
    item_total += (item.quantity * item.price)
  end
  o1.item_count = item_count
  o1.item_total = item_total
  o1.total = item_total
  o1.save
end

12.times do |mo|
  o1 = v4.orders.create(customer_id: c10.id, ship_address_id: c10.ship_address_id, bill_address_id: c10.ship_address_id, email: c10.email,
    delivery_date: DateTime.new(2015, mo + 1, 15))

  o1.line_items.create(variant_id: var1.id, quantity: rand(12..100))
  o1.line_items.create(variant_id: var2.id, quantity: rand(12..100))
  o1.line_items.create(variant_id: var3.id, quantity: rand(1..10))
  o1.line_items.create(variant_id: var4.id, quantity: rand(1..10))
  o1.line_items.create(variant_id: var5.id, quantity: rand(12..100))
  o1.line_items.create(variant_id: var6.id, quantity: rand(12..100))
  o1.line_items.create(variant_id: var7.id, quantity: rand(12..100))
  o1.line_items.create(variant_id: var8.id, quantity: rand(12..100))

  item_count = 0
  item_total = 0
  o1.line_items.each do |item|
    item_count += item.quantity
    item_total += (item.quantity * item.price)
  end
  o1.item_count = item_count
  o1.item_total = item_total
  o1.total = item_total
  o1.save
end

###############################################################################
# Vendor 5 - Billy's Bakery :Products, Variants, Orders > Li
###############################################################################
p1 = v5.products.create(name: "Blueberry Pie", price: 6.00, shipping_category_id: 1, available_on: available_date,
  description: "Rich blueberry filling in a buttery crust.")
p2 = v5.products.create(name: "Chocolate Fudge Brownie", price: 3.25, shipping_category_id: 1, available_on: available_date,
  description: "Rich and fudgy deep chocolate brownies.")
p3 = v5.products.create(name: "Yellow Daisy Cake with Chocolate Buttercream", price: 45.00, shipping_category_id: 1, available_on: available_date,
  description: "Classic yellow butter cake flavored with chocolate buttercream.")
p4 = v5.products.create(name: "Pecan Pear Hand Pie", price: 3.00, shipping_category_id: 1, available_on: available_date,
  description: "Delicious Pear cookie with pecans.")
p5 = v5.products.create(name: "Gingerbread Cupcake", price: 3.50, shipping_category_id: 1, available_on: available_date,
  description: "Gingerbread batter with a cream cheese frosting")
p6 = v5.products.create(name: "Yellow Daisy Cupcake with Vanilla Buttercream", price: 3.50, shipping_category_id: 1, available_on: available_date,
  description: "Classic yellow butter cake flavored with pure vanilla extract.")
p7 = v5.products.create(name: "German Chocolate Cupcake", price: 3.50, shipping_category_id: 1, available_on: available_date,
  description: "Sweet buttermilk chocolate cake with coconut pecan topping.")
p8 = v5.products.create(name: "Nutella Cheesecake", price: 30.00, shipping_category_id: 1, available_on: available_date,
  description: "Classic Nutella flavored")
p9 = v5.products.create(name: "Banana Cream Pie", price: 26, shipping_category_id: 1, available_on: available_date,
  description: "Fresh banana slices layered with vanilla pudding and topped with whipped cream.")
p10 = v5.products.create(name: "Chocolate Chip Cookie Sandwich", price: 2.50, shipping_category_id: 1, available_on: available_date,
  description: "Buttercream icing sandwiched between homestyle cookies.")

var1 = p1.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var2 = p2.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var3 = p3.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var4 = p4.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var5 = p5.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var6 = p6.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var7 = p7.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var8 = p8.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var9 = p9.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
var10 = p10.variants.create(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)

var1.stock_items.create(stock_location_id: sl5.id)
var2.stock_items.create(stock_location_id: sl5.id)
var3.stock_items.create(stock_location_id: sl5.id)
var4.stock_items.create(stock_location_id: sl5.id)
var5.stock_items.create(stock_location_id: sl5.id)
var6.stock_items.create(stock_location_id: sl5.id)
var7.stock_items.create(stock_location_id: sl5.id)
var8.stock_items.create(stock_location_id: sl5.id)
var9.stock_items.create(stock_location_id: sl5.id)
var10.stock_items.create(stock_location_id: sl5.id)

12.times do |mo|
  o1 = v5.orders.create(customer_id: c6.id, ship_address_id: c6.ship_address_id, bill_address_id: c6.ship_address_id, email: c6.email,
    delivery_date: DateTime.new(2015, mo + 1, 28))
  o1.line_items.create(variant_id: var1.id, quantity: rand(12..100))
  o1.line_items.create(variant_id: var2.id, quantity: rand(12..100))
  o1.line_items.create(variant_id: var3.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var4.id, quantity: rand(12..100))
  o1.line_items.create(variant_id: var5.id, quantity: rand(12..100))
  o1.line_items.create(variant_id: var6.id, quantity: rand(12..100))
  o1.line_items.create(variant_id: var7.id, quantity: rand(12..100))
  o1.line_items.create(variant_id: var8.id, quantity: rand(1..5))
  o1.line_items.create(variant_id: var9.id, quantity: rand(12..100))
  o1.line_items.create(variant_id: var10.id, quantity: rand(12..100))

  item_count = 0
  item_total = 0
  o1.line_items.each do |item|
    item_count += item.quantity
    item_total += (item.quantity * item.price)
  end
  o1.item_count = item_count
  o1.item_total = item_total
  o1.total = item_total
  o1.save
end


12.times do |mo|
  o1 = v5.orders.create(customer_id: c7.id, ship_address_id: c7.ship_address_id, bill_address_id: c7.ship_address_id, email: c7.email,
    delivery_date: DateTime.new(2015, mo + 1, 15))

    o1.line_items.create(variant_id: var1.id, quantity: rand(12..100))
    o1.line_items.create(variant_id: var2.id, quantity: rand(12..100))
    o1.line_items.create(variant_id: var3.id, quantity: rand(1..5))
    o1.line_items.create(variant_id: var4.id, quantity: rand(12..100))
    o1.line_items.create(variant_id: var5.id, quantity: rand(12..100))
    o1.line_items.create(variant_id: var6.id, quantity: rand(12..100))
    o1.line_items.create(variant_id: var7.id, quantity: rand(12..100))
    o1.line_items.create(variant_id: var8.id, quantity: rand(1..5))
    o1.line_items.create(variant_id: var9.id, quantity: rand(12..100))
    o1.line_items.create(variant_id: var10.id, quantity: rand(12..100))

    item_count = 0
    item_total = 0
    o1.line_items.each do |item|
      item_count += item.quantity
      item_total += (item.quantity * item.price)
    end
    o1.item_count = item_count
    o1.item_total = item_total
    o1.total = item_total
    o1.save
end

12.times do |mo|
  o1 = v5.orders.create(customer_id: c8.id, ship_address_id: c8.ship_address_id, bill_address_id: c8.ship_address_id, email: c8.email,
    delivery_date: DateTime.new(2015, mo + 1, 15))

    o1.line_items.create(variant_id: var1.id, quantity: rand(12..100))
    o1.line_items.create(variant_id: var2.id, quantity: rand(12..100))
    o1.line_items.create(variant_id: var3.id, quantity: rand(1..5))
    o1.line_items.create(variant_id: var4.id, quantity: rand(12..100))
    o1.line_items.create(variant_id: var5.id, quantity: rand(12..100))
    o1.line_items.create(variant_id: var6.id, quantity: rand(12..100))
    o1.line_items.create(variant_id: var7.id, quantity: rand(12..100))
    o1.line_items.create(variant_id: var8.id, quantity: rand(1..5))
    o1.line_items.create(variant_id: var9.id, quantity: rand(12..100))
    o1.line_items.create(variant_id: var10.id, quantity: rand(12..100))

    item_count = 0
    item_total = 0
    o1.line_items.each do |item|
      item_count += item.quantity
      item_total += (item.quantity * item.price)
    end
    o1.item_count = item_count
    o1.item_total = item_total
    o1.total = item_total
    o1.save
end

12.times do |mo|
  o1 = v5.orders.create(customer_id: c9.id, ship_address_id: c9.ship_address_id, bill_address_id: c9.ship_address_id, email: c9.email,
    delivery_date: DateTime.new(2015, mo + 1, 15))

    o1.line_items.create(variant_id: var1.id, quantity: rand(12..100))
    o1.line_items.create(variant_id: var2.id, quantity: rand(12..100))
    o1.line_items.create(variant_id: var3.id, quantity: rand(1..5))
    o1.line_items.create(variant_id: var4.id, quantity: rand(12..100))
    o1.line_items.create(variant_id: var5.id, quantity: rand(12..100))
    o1.line_items.create(variant_id: var6.id, quantity: rand(12..100))
    o1.line_items.create(variant_id: var7.id, quantity: rand(12..100))
    o1.line_items.create(variant_id: var8.id, quantity: rand(1..5))
    o1.line_items.create(variant_id: var9.id, quantity: rand(12..100))
    o1.line_items.create(variant_id: var10.id, quantity: rand(12..100))

    item_count = 0
    item_total = 0
    o1.line_items.each do |item|
      item_count += item.quantity
      item_total += (item.quantity * item.price)
    end
    o1.item_count = item_count
    o1.item_total = item_total
    o1.total = item_total
    o1.save
end

12.times do |mo|
  o1 = v5.orders.create(customer_id: c10.id, ship_address_id: c10.ship_address_id, bill_address_id: c10.ship_address_id, email: c10.email,
    delivery_date: DateTime.new(2015, mo + 1, 15))

    o1.line_items.create(variant_id: var1.id, quantity: rand(12..100))
    o1.line_items.create(variant_id: var2.id, quantity: rand(12..100))
    o1.line_items.create(variant_id: var3.id, quantity: rand(1..5))
    o1.line_items.create(variant_id: var4.id, quantity: rand(12..100))
    o1.line_items.create(variant_id: var5.id, quantity: rand(12..100))
    o1.line_items.create(variant_id: var6.id, quantity: rand(12..100))
    o1.line_items.create(variant_id: var7.id, quantity: rand(12..100))
    o1.line_items.create(variant_id: var8.id, quantity: rand(1..5))
    o1.line_items.create(variant_id: var9.id, quantity: rand(12..100))
    o1.line_items.create(variant_id: var10.id, quantity: rand(12..100))

    item_count = 0
    item_total = 0
    o1.line_items.each do |item|
      item_count += item.quantity
      item_total += (item.quantity * item.price)
    end
    o1.item_count = item_count
    o1.item_total = item_total
    o1.total = item_total
    o1.save
end
