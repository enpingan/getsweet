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

vendor = Spree::Role.create(name: 'vendor')
customer = Spree::Role.create(name: 'customer')

sc1 = Spree::ShippingCategory.create(name: "Standard")
sc2 = Spree::ShippingCategory.create(name: "Over Size")

tc = Spree::TaxCategory.create(name: "Food", is_default: false)
pm = Spree::PaymentMethod.create(type: "Spree::PaymentMethod::Check", name: "Check", description: "", active: true, display_on: "", preferences: {})

pickup_calc = Spree::Calculator.create(
	type: "Spree::Calculator::Shipping::FlatRate",
	calculable_type: "Spree::ShippingMethod",
	preferences: {amount: 0, :currency=>"USD"}
)

ship_calc = Spree::Calculator.create(
	type: "Spree::Calculator::Shipping::FlatRate",
	calculable_type: "Spree::ShippingMethod",
	preferences: {amount: 7.00, :currency=>"USD"}
)

sm = Spree::ShippingMethod.new(name: "Pick Up", admin_name: 'pick_up', display_on: 'Both', tax_category_id: tc.id)
sm2 = Spree::ShippingMethod.new(name: "Delivery", admin_name: 'delivery', display_on: 'Both', tax_category_id: tc.id)

sm.calculator = pickup_calc
sm2.calculator = ship_calc

sm.shipping_categories = Spree::ShippingCategory.all
sm2.shipping_categories = Spree::ShippingCategory.all

sm.zones = Spree::Zone.all
sm2.zones = Spree::Zone.all

sm.save!
sm2.save!


def image(name, type="jpeg")
	curr_dir = "#{File.expand_path File.dirname(__FILE__)}"
  images_path = "#{curr_dir}/images/"
  path = images_path + "#{name}.#{type}"
  if !File.exist?(path)
		puts "Unable to find seed image for #{name} at #{path}"
		return false
	else
  	File.open(path)
	end
end

def submit(order)
	order.state = "complete"
	order.completed_at = order.delivery_date - 1.days
	order.save!
end

def approve(order)
	order.approver_id = order.vendor.users.first.id
	order.approved_at = order.delivery_date - 1.days
	order.approved = true
	shipment = order.shipments.create(stock_location_id: order.vendor.stock_locations.last.id)
	order.line_items.each do |line_item|
		shipment.inventory_units.create(
			order_id: order.id,
			line_item_id: line_item.id,
			variant_id: line_item.variant_id
		)
	end
	shipment.shipping_rates.create(shipping_method_id: Spree::ShippingMethod.first.id)
	shipment.state = 'ready'
	order.shipment_state = 'ready'
	order.save!
end

def ship(order)
	shipment = order.shipments.first
	shipment.state = 'shipped'
	shipment.shipped_at = order.delivery_date
	shipment.save!
	order.line_items.each do |line_item|
		line_item.shipped_qty = line_item.quantity
		line_item.shipped_total = line_item.shipped_qty * line_item.price
	end
	order.shipment_state = 'shipped'
	order.save!
end

def receive(order)
	shipment = order.shipments.first
	shipment.state = 'received'
	shipment.receiver_id = order.user_id
	shipment.received_at = order.delivery_date
	shipment.save!
	order.line_items.each do |line_item|
		line_item.received_qty = line_item.shipped_qty
		line_item.received_total = line_item.received_qty * line_item.price
		line_item.confirm_received = true
	end
	order.shipment_state = 'received'
	order.save!
end

##############################################################################
# Create users
##############################################################################
u1 = Spree::User.create(email: 'john_dough@sweetist.co', firstname: 'John', lastname: Faker::Name.last_name, phone: Faker::PhoneNumber.phone_number, vendor_id: 1, password: 'password')
u1.spree_roles << vendor
u1.save!
u2 = Spree::User.create(email: 'mark_cecicela@sweetist.co', firstname: 'Mark', lastname: Faker::Name.last_name, phone: Faker::PhoneNumber.phone_number, vendor_id: 2, password: 'password')
u2.spree_roles << vendor
u2.save!
u3 = Spree::User.create(email: 'celine@sweetist.co', firstname: 'Celine', lastname: Faker::Name.last_name, phone: Faker::PhoneNumber.phone_number, vendor_id: 3, password: 'password')
u3.spree_roles << vendor
u3.save!
u4 = Spree::User.create(email: 'mary_chika@sweetist.co', firstname: 'Mary', lastname: Faker::Name.last_name, phone: Faker::PhoneNumber.phone_number, vendor_id: 4, password: 'password')
u4.spree_roles << vendor
u4.save!
u5 = Spree::User.create(email: 'pain_davignon@getsweet.co', firstname: 'Joanne', lastname: Faker::Name.last_name, phone: Faker::PhoneNumber.phone_number, vendor_id: 5, password: 'password')
u5.spree_roles << vendor
u5.save!

u6 = Spree::User.create(email: 'amy_creekside@sweetist.co', firstname: 'Amy', lastname: Faker::Name.last_name, phone: Faker::PhoneNumber.phone_number, customer_id: 1, password: 'password')
u6.spree_roles << customer
u6.save!
u7 = Spree::User.create(email: 'michael_whotel@sweetist.co', firstname: 'Michael', lastname: Faker::Name.last_name, phone: Faker::PhoneNumber.phone_number, customer_id: 2, password: 'password')
u7.spree_roles << customer
u7.save!
u8 = Spree::User.create(email: 'kat_frenchcafe@sweetist.co', firstname: 'Kathleen', lastname: Faker::Name.last_name, phone: Faker::PhoneNumber.phone_number, customer_id: 3, password: 'password')
u8.spree_roles << customer
u8.save!
u9 = Spree::User.create(email: 'myles_murrays@sweetist.co', firstname: 'Myles', lastname: Faker::Name.last_name, phone: Faker::PhoneNumber.phone_number, customer_id: 4, password: 'password')
u9.spree_roles << customer
u9.save!
u10 = Spree::User.create(email: 'pete_knickerbocker@sweetist.co', firstname: 'Pete', lastname: Faker::Name.last_name, phone: Faker::PhoneNumber.phone_number, customer_id: 5, password: 'password')
u10.spree_roles << customer
u10.save!

v1 = Spree::Vendor.create(name: 'Dough Donuts', email: 'orderdoughdonuts@sweetist.co', order_cutoff_time: '5PM EST', delivery_minimum: 10.0, payment_terms: 30)
v2 = Spree::Vendor.create(name: 'Ceci Cela', email: 'ordercecicela@sweetist.co',order_cutoff_time: '6PM EST', delivery_minimum: 10.0, payment_terms: 30)
v3 = Spree::Vendor.create(name: 'Canele by Celine', email: 'ordercanelebyceline@sweetist.co', order_cutoff_time: '8PM EST', delivery_minimum: 10.0, payment_terms: 0)
v4 = Spree::Vendor.create(name: "Chikalicious", email: 'orderchikalicious@sweetist.co', order_cutoff_time: '9PM EST', delivery_minimum: 10.0, payment_terms: 15)
v5 = Spree::Vendor.create(name: "Pain D'Avignon", email: 'orderpaindavignon@sweetist.co', order_cutoff_time: '5PM EST', delivery_minimum: 10.0, payment_terms: 45)

c6 = Spree::Customer.create(name: "Creek Side Cafe", spree_account_id: '47584', email: "contact_creekside@sweetist.co")
c7 = Spree::Customer.create(name: "W Hotel", spree_account_id: '85893', email: "contact_whotel@sweetist.co")
c8 = Spree::Customer.create(name: "French Cafe", spree_account_id: '57203', email: "contact_frenchcafe@sweetist.co")
c9 = Spree::Customer.create(name: "Murray's", spree_account_id: '60593', email: "contact_murrays@sweetist.co")
c10 = Spree::Customer.create(name: "Knickerbocker Club", spree_account_id: '29493', email: "contact_knickerbocker@sweetist.co")

c6.build_ship_address(firstname: u6.firstname, lastname: u6.lastname, address1: Faker::Address.street_address, city: 'New York', zipcode: '10005', phone: u6.phone,
  state_name: 'New York', company: c6.name, country_id: 232)
c7.build_ship_address(firstname: u7.firstname, lastname: u7.lastname, address1: Faker::Address.street_address, city: 'New York', zipcode: '10005', phone: u7.phone,
  state_name: 'New York', company: c7.name, country_id: 232)
c8.build_ship_address(firstname: u8.firstname, lastname: u8.lastname, address1: Faker::Address.street_address, city: 'New York', zipcode: '10005', phone: u8.phone,
  state_name: 'New York', company: c8.name, country_id: 232)
c9.build_ship_address(firstname: u9.firstname, lastname: u9.lastname, address1: Faker::Address.street_address, city: 'New York', zipcode: '10005', phone: u9.phone,
  state_name: 'New York', company: c9.name, country_id: 232)
c10.build_ship_address(firstname: u10.firstname, lastname: u10.lastname, address1: Faker::Address.street_address, city: 'New York', zipcode: '10005', phone: u10.phone,
  state_name: 'New York', company: c10.name, country_id: 232)

# c6.vendors += [v1, v2, v3, v4, v5]
# c7.vendors += [v1, v2, v3, v4, v5]
# c8.vendors += [v1, v2, v3, v4, v5]
# c9.vendors += [v1, v2, v3, v4, v5]
# c10.vendors += [v1, v2, v3, v4, v5]

c6.save!
c7.save!
c8.save!
c9.save!
c10.save!


sl1 = v1.stock_locations.create(name: v1.name, backorderable_default: true)
sl2 = v2.stock_locations.create(name: v2.name, backorderable_default: true)
sl3 = v3.stock_locations.create(name: v3.name, backorderable_default: true)
sl4 = v4.stock_locations.create(name: v4.name, backorderable_default: true)
sl5 = v5.stock_locations.create(name: v5.name, backorderable_default: true)

available_date = Time.zone.local(2013, 1, 1)

###############################################################################
# Vendor 1 - Dough Donuts :Products, Variants, Orders > Li
###############################################################################
a6 = v1.accounts.create(payment_terms: 15, customer_id: c6.id, number: rand(1000000...10000000).to_s)
a7 = v1.accounts.create(payment_terms: 15, customer_id: c7.id, number: rand(1000000...10000000).to_s)
a8 = v1.accounts.create(payment_terms: 15, customer_id: c8.id, number: rand(1000000...10000000).to_s)
a9 = v1.accounts.create(payment_terms: 15, customer_id: c9.id, number: rand(1000000...10000000).to_s)
a10 = v1.accounts.create(payment_terms: 15, customer_id: c10.id, number: rand(1000000...10000000).to_s)

p1 = v1.products.create(name: "Cafe Au Lait", price: 3.00, shipping_category_id: 1, available_on: available_date,
  description: "One of Dough's most popular flavors. A blend of fresh roasted coffee beans and pecan brown sugar tops our signature glaze.", pack_size: "Each")
p2 = v1.products.create(name: "Chocolate with Cocoa Nibbs", price: 3.00, shipping_category_id: 1, available_on: available_date,
  description: "This rich delicacy celebrates classic pastries using chocolate fondant and finished with decadent hand shaven cocoa nibs.", pack_size: "Each")
p3 = v1.products.create(name: "Chocolate Salted Caramel", price: 3.00, shipping_category_id: 1, available_on: available_date,
  description: "Belgium dark chocolate infused with French caramel and sprinkled with Mediterranean sea-salt.", pack_size: "Each")
p4 = v1.products.create(name: "Cinnamon Sugar", price: 3.00, shipping_category_id: 1, available_on: available_date,
  description: "Using the best cinnamon Mexico has to offer, this flavor is sure to warm your taste buds.", pack_size: "Each")
p5 = v1.products.create(name: "Mocha Almond Crunch", price: 3.00, shipping_category_id: 1, available_on: available_date,
  description: "", pack_size: "Each")
p6 = v1.products.create(name: "Glazed", price: 3.00, shipping_category_id: 1, available_on: available_date,
  description: "'The Original' simply a best seller. Dough uses a signature glaze with it's perfect balance of sweetness over our oversized soft dough that make this a classic.", pack_size: "Each")
p7 = v1.products.create(name: "Dulce de Leche", price: 3.00, shipping_category_id: 1, available_on: available_date,
  description: "Spanish for 'candy of milk', this rich and creamy luxurious glaze is topped with a delicate toasted almond crunch.", pack_size: "Each")
p8 = v1.products.create(name: "Hibiscus", price: 3.00, shipping_category_id: 1, available_on: available_date,
  description: "A sweet and tangy glaze transforms the subtle floral flavors of imported Mexican hibiscus into our most unique creation.", pack_size: "Each")
p9 = v1.products.create(name: "Lemon Poppy", price: 3.00, shipping_category_id: 1, available_on: available_date,
  description: "A glaze of sweet and fresh lemon juice is topped with Turkish poppy seeds and light lemon zest.", pack_size: "Each")
p10 = v1.products.create(name: "Filled Nutella", price: 3.50, shipping_category_id: 1, available_on: available_date,
  description: "Delectable Nutella filled doughnut.", pack_size: "Each")

p1.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
p2.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
p3.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
p4.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
p5.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
p6.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
p7.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
p8.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
p9.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
p10.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)

var1 = p1.master
var2 = p2.master
var3 = p3.master
var4 = p4.master
var5 = p5.master
var6 = p6.master
var7 = p7.master
var8 = p8.master
var9 = p9.master
var10 = p10.master

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

# load images for each product, need to convert product name to lowercase, underscore-separated name which corresponds to seed image file names
p1.master.images.create!({:attachment => image(p1.name.gsub(/ /,"_").downcase)})
p2.master.images.create!({:attachment => image(p2.name.gsub(/ /,"_").downcase)})
p3.master.images.create!({:attachment => image(p3.name.gsub(/ /,"_").downcase)})
p4.master.images.create!({:attachment => image(p4.name.gsub(/ /,"_").downcase)})
p5.master.images.create!({:attachment => image(p5.name.gsub(/ /,"_").downcase)})
p6.master.images.create!({:attachment => image(p6.name.gsub(/ /,"_").downcase)})
p7.master.images.create!({:attachment => image(p7.name.gsub(/ /,"_").downcase)})
p8.master.images.create!({:attachment => image(p8.name.gsub(/ /,"_").downcase)})
p9.master.images.create!({:attachment => image(p9.name.gsub(/ /,"_").downcase)})
p10.master.images.create!({:attachment => image(p10.name.gsub(/ /,"_").downcase)})

12.times do |mo|
  o1 = v1.orders.create(customer_id: c6.id, ship_address_id: c6.ship_address_id, bill_address_id: c6.ship_address_id, email: c6.email,
    delivery_date: Time.zone.local(2015, mo + 1, 28), user_id: u6.id, created_by_id: u6.id, account_id: a6.id)
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

  o1.payments.create(payment_method_id: Spree::PaymentMethod.last.id)
  if o1.delivery_date < Time.current
    o1.state = "complete"
    o1.completed_at = o1.delivery_date
  end
	submit(o1)

	if o1.delivery_date < Time.current
		approve(o1)
		ship(o1)
		receive(o1)
	end
  o1.save
end

12.times do |mo|
  o1 = v1.orders.create(customer_id: c7.id, ship_address_id: c7.ship_address_id, bill_address_id: c7.ship_address_id, email: c7.email,
    delivery_date: Time.zone.local(2015, mo + 1, 28), user_id: u7.id, created_by_id: u7.id, account_id: a7.id)

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
  o1.payments.create(payment_method_id: Spree::PaymentMethod.last.id)
  if o1.delivery_date < Time.current
    o1.state = "complete"
    o1.completed_at = o1.delivery_date
  end
	submit(o1)

	if o1.delivery_date < Time.current
		approve(o1)
		ship(o1)
		receive(o1)
	end
  o1.save
end

12.times do |mo|
  o1 = v1.orders.create(customer_id: c8.id, ship_address_id: c8.ship_address_id, bill_address_id: c8.ship_address_id, email: c8.email,
    delivery_date: Time.zone.local(2015, mo + 1, 28), user_id: u8.id, created_by_id: u8.id, account_id: a8.id)
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
  o1.payments.create(payment_method_id: Spree::PaymentMethod.last.id)
  if o1.delivery_date < Time.current
    o1.state = "complete"
    o1.completed_at = o1.delivery_date
  end
	submit(o1)

	if o1.delivery_date < Time.current
		approve(o1)
		ship(o1)
		receive(o1)
	end
  o1.save
end

12.times do |mo|
  o1 = v1.orders.create(customer_id: c9.id, ship_address_id: c9.ship_address_id, bill_address_id: c9.ship_address_id, email: c9.email,
    delivery_date: Time.zone.local(2015, mo + 1, 28), user_id: u9.id, created_by_id: u9.id, account_id: a9.id)
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
  o1.payments.create(payment_method_id: Spree::PaymentMethod.last.id)
  if o1.delivery_date < Time.current
    o1.state = "complete"
    o1.completed_at = o1.delivery_date
  end
	submit(o1)

	if o1.delivery_date < Time.current
		approve(o1)
		ship(o1)
		receive(o1)
	end
  o1.save
end

12.times do |mo|
  o1 = v1.orders.create(customer_id: c10.id, ship_address_id: c10.ship_address_id, bill_address_id: c10.ship_address_id, email: c10.email,
    delivery_date: Time.zone.local(2015, mo + 1, 28), user_id: u10.id, created_by_id: u10.id, account_id: a10.id)
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
  o1.payments.create(payment_method_id: Spree::PaymentMethod.last.id)
  if o1.delivery_date < Time.current
    o1.state = "complete"
    o1.completed_at = o1.delivery_date
  end
	submit(o1)

	if o1.delivery_date < Time.current
		approve(o1)
		ship(o1)
		receive(o1)
	end
  o1.save
end

###############################################################################
# Vendor 2 - Ceci Cela :Products, Variants, Orders > Li
###############################################################################
a6 = v2.accounts.create(payment_terms: 15, customer_id: c6.id, number: rand(1000000...10000000).to_s)
a7 = v2.accounts.create(payment_terms: 15, customer_id: c7.id, number: rand(1000000...10000000).to_s)
a8 = v2.accounts.create(payment_terms: 15, customer_id: c8.id, number: rand(1000000...10000000).to_s)
a9 = v2.accounts.create(payment_terms: 15, customer_id: c9.id, number: rand(1000000...10000000).to_s)
a10 = v2.accounts.create(payment_terms: 15, customer_id: c10.id, number: rand(1000000...10000000).to_s)

p1 = v2.products.create(name: "Apple Tart", price: 26.00, shipping_category_id: 1, available_on: available_date,
  description: "", pack_size: "Each")
p2 = v2.products.create(name: "Pear Tart", price: 26.00, shipping_category_id: 1, available_on: available_date,
  description: "", pack_size: "Each")
p3 = v2.products.create(name: "Lemon Tart", price: 26.00, shipping_category_id: 1, available_on: available_date,
  description: "Delicious rich and refreshing lemon tart", pack_size: "Each")
p4 = v2.products.create(name: "Fruit Tart", price: 35.00, shipping_category_id: 1, available_on: available_date,
  description: "Sugar crust covered with chocolate, pastry cream, fresh fruit", pack_size: "Each")
p5 = v2.products.create(name: "Paradise Cake", price: 36.00, shipping_category_id: 1, available_on: available_date,
  description: "Mix of guava, mango, passion fruit mousse with fresh fruit on top", pack_size: "Each")
p6 = v2.products.create(name: "Chocolate Cake", price: 33.00, shipping_category_id: 1, available_on: available_date,
  description: "Layers of chocolate cake and mousse", pack_size: "Each")
p7 = v2.products.create(name: "Black Forest Cake", price: 36.00, shipping_category_id: 1, available_on: available_date,
  description: "Chocolate cake with vanilla cream and brandied cherries", pack_size: "Each")
p8 = v2.products.create(name: "Pear William Cake", price: 36.00, shipping_category_id: 1, available_on: available_date,
  description: "Vanilla cake with sliced pears", pack_size: "Each")
p9 = v2.products.create(name: "Strawberry Charlotte", price: 36.00, shipping_category_id: 1, available_on: available_date,
  description: "Strawberry mousse surrounded by ladyfingers", pack_size: "Each")
p10 = v2.products.create(name: "Tiramisu", price: 36.00, shipping_category_id: 1, available_on: available_date,
  description: "Mascarpone cheese mousse, espresso sponged ladyfingers, marcalas liquor surrounded by ladyfingers", pack_size: "Each")

  p1.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
  p2.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
  p3.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
  p4.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
  p5.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
  p6.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
  p7.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
  p8.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
  p9.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
  p10.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)

  var1 = p1.master
  var2 = p2.master
  var3 = p3.master
  var4 = p4.master
  var5 = p5.master
  var6 = p6.master
  var7 = p7.master
  var8 = p8.master
  var9 = p9.master
  var10 = p10.master

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

p1.master.images.create!({:attachment => image(p1.name.gsub(/ /,"_").downcase)})
p2.master.images.create!({:attachment => image(p2.name.gsub(/ /,"_").downcase)})
p3.master.images.create!({:attachment => image(p3.name.gsub(/ /,"_").downcase)})
p4.master.images.create!({:attachment => image(p4.name.gsub(/ /,"_").downcase)})
p5.master.images.create!({:attachment => image(p5.name.gsub(/ /,"_").downcase)})
p6.master.images.create!({:attachment => image(p6.name.gsub(/ /,"_").downcase)})
p7.master.images.create!({:attachment => image(p7.name.gsub(/ /,"_").downcase)})
p8.master.images.create!({:attachment => image(p8.name.gsub(/ /,"_").downcase)})
p9.master.images.create!({:attachment => image(p9.name.gsub(/ /,"_").downcase)})
p10.master.images.create!({:attachment => image(p10.name.gsub(/ /,"_").downcase)})

12.times do |mo|
  o1 = v2.orders.create(customer_id: c6.id, ship_address_id: c6.ship_address_id, bill_address_id: c6.ship_address_id, email: c6.email,
    delivery_date: Time.zone.local(2015, mo + 1, 28), user_id: u6.id, created_by_id: u6.id, account_id: a6.id)
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
  o1.payments.create(payment_method_id: Spree::PaymentMethod.last.id)
  if o1.delivery_date < Time.current
    o1.state = "complete"
    o1.completed_at = o1.delivery_date
  end
	submit(o1)

	if o1.delivery_date < Time.current
		approve(o1)
		ship(o1)
		receive(o1)
	end
  o1.save
end

12.times do |mo|
  o1 = v2.orders.create(customer_id: c7.id, ship_address_id: c7.ship_address_id, bill_address_id: c7.ship_address_id, email: c7.email,
    delivery_date: Time.zone.local(2015, mo + 1, 28), user_id: u7.id, created_by_id: u7.id, account_id: a7.id)

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
  o1.payments.create(payment_method_id: Spree::PaymentMethod.last.id)
  if o1.delivery_date < Time.current
    o1.state = "complete"
    o1.completed_at = o1.delivery_date
  end
	submit(o1)

	if o1.delivery_date < Time.current
		approve(o1)
		ship(o1)
		receive(o1)
	end
  o1.save
end

12.times do |mo|
  o1 = v2.orders.create(customer_id: c8.id, ship_address_id: c8.ship_address_id, bill_address_id: c8.ship_address_id, email: c8.email,
    delivery_date: Time.zone.local(2015, mo + 1, 28), user_id: u8.id, created_by_id: u8.id, account_id: a8.id)
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
  o1.payments.create(payment_method_id: Spree::PaymentMethod.last.id)
  if o1.delivery_date < Time.current
    o1.state = "complete"
    o1.completed_at = o1.delivery_date
  end
	submit(o1)

	if o1.delivery_date < Time.current
		approve(o1)
		ship(o1)
		receive(o1)
	end
  o1.save
end

12.times do |mo|
  o1 = v2.orders.create(customer_id: c9.id, ship_address_id: c9.ship_address_id, bill_address_id: c9.ship_address_id, email: c9.email,
    delivery_date: Time.zone.local(2015, mo + 1, 28), user_id: u9.id, created_by_id: u9.id, account_id: a9.id)
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
  o1.payments.create(payment_method_id: Spree::PaymentMethod.last.id)
  if o1.delivery_date < Time.current
    o1.state = "complete"
    o1.completed_at = o1.delivery_date
  end
	submit(o1)

	if o1.delivery_date < Time.current
		approve(o1)
		ship(o1)
		receive(o1)
	end
  o1.save
end

12.times do |mo|
  o1 = v2.orders.create(customer_id: c10.id, ship_address_id: c10.ship_address_id, bill_address_id: c10.ship_address_id, email: c10.email,
    delivery_date: Time.zone.local(2015, mo + 1, 28), user_id: u10.id, created_by_id: u10.id, account_id: a10.id)
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
  o1.payments.create(payment_method_id: Spree::PaymentMethod.last.id)
  if o1.delivery_date < Time.current
    o1.state = "complete"
    o1.completed_at = o1.delivery_date
  end
	submit(o1)

	if o1.delivery_date < Time.current
		approve(o1)
		ship(o1)
		receive(o1)
	end
  o1.save
end
###############################################################################
# Vendor 3 - Canele by Celine :Products, Variants, Orders > Li
###############################################################################
a6 = v3.accounts.create(payment_terms: 15, customer_id: c6.id, number: rand(1000000...10000000).to_s)
a7 = v3.accounts.create(payment_terms: 30, customer_id: c7.id, number: rand(1000000...10000000).to_s)
a8 = v3.accounts.create(payment_terms: 30, customer_id: c8.id, number: rand(1000000...10000000).to_s)
a9 = v3.accounts.create(payment_terms: 30, customer_id: c9.id, number: rand(1000000...10000000).to_s)
a10 = v3.accounts.create(payment_terms: 15, customer_id: c10.id, number: rand(1000000...10000000).to_s)

p1 = v3.products.create(name: "Sweet Canele (Selection of 3)", price: 4.90, shipping_category_id: 1, available_on: available_date,
  description: "A bag of 3 mini canelés. A petite pastry which has a caramelized crust which protects a moist and tender heart, like a crème brûlèe. Let the bakery know which flavors you want by leaving a note in the comment box below. Select from: Caramel, Cinnamon, Dark Chocolate, Gingerbread, Hazelnut (Contains nuts), Lemon, Lime, Mint Choco, Nougat (Contains nuts), Orange, Orange Blossom, Pink Praline (Contains nuts), Pistachio (Contains nuts), Raspberry, Rose Water, Rum, Vanilla.", pack_size: "Each")
p2 = v3.products.create(name: "Savory Canele (Selection of 3)", price: 5.90, shipping_category_id: 1, available_on: available_date,
  description: "A bag of 3 mini canelés. A petite pastry which has a caramelized crust which protects a moist and tender heart, like a crème brûlée. If you would like a selection of flavors, let the bakery know which flavors you want by leaving a note in the comment box below.", pack_size: "Each")
p3 = v3.products.create(name: "Mini Glass Bell Jar (With 3 Mini Caneles)", price: 15.00, shipping_category_id: 1, available_on: available_date,
  description: "3 mini caneles in the flavor of you choice, displayed in a glass jar. Select your flavor and let the bakery know your choice in the comments box. Sweet flavors to choose from: Caramel, Dark Chocolate, Gingerbread, Lemon, Lime, Mint Choco, Orange, Orange Blossom, Pink Praline (Contains nuts), Pistachio (Contains nuts), Raspberry, Rose Water, Rum, Vanilla, (Seasonal flavors: Hazelnut (Contains nuts), Nougat (Contains nuts), Cinnamon). Savory Flavors to choose from: Black Olive, Cheese, Chorizo, Pesto, Truffle.", pack_size: "Each")
p4 = v3.products.create(name: "Box of 9 Mini Caneles", price: 19.80, shipping_category_id: 1, available_on: available_date,
  description: "A selection of 9 canelés of your choice, select either sweet or savory canelés. Select your flavors and let the bakery know your choice in the comments box. Sweet flavors to choose from: Caramel, Dark Chocolate, Gingerbread, Lemon, Lime, Mint Choco, Orange, Orange Blossom, Pink Praline (Contains nuts), Pistachio (Contains nuts), Raspberry, Rose Water, Rum, Vanilla, (Seasonal flavors: Hazelnut (Contains nuts), Nougat (Contains nuts), Cinnamon). Savory Flavors to choose from: Black Olive, Cheese, Chorizo, Pesto, Truffle.", pack_size: "Each")
p5 = v3.products.create(name: "Large Canele (Selection of 6)", price: 21.00, shipping_category_id: 1, available_on: available_date,
  description: "A selection of 6 canelés of your choice. If you would like a selection, let the bakery know your choice of flavors in the comments box.", pack_size: "Each")


  p1.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
  p2.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
  p3.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
  p4.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
  p5.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)

  var1 = p1.master
  var2 = p2.master
  var3 = p3.master
  var4 = p4.master
  var5 = p5.master

var1.stock_items.create(stock_location_id: sl3.id)
var2.stock_items.create(stock_location_id: sl3.id)
var3.stock_items.create(stock_location_id: sl3.id)
var4.stock_items.create(stock_location_id: sl3.id)
var5.stock_items.create(stock_location_id: sl3.id)

p1.master.images.create!({:attachment => image(p1.name.gsub(/ /,"_").downcase)})
p2.master.images.create!({:attachment => image(p2.name.gsub(/ /,"_").downcase)})
p3.master.images.create!({:attachment => image(p3.name.gsub(/ /,"_").downcase)})
p4.master.images.create!({:attachment => image(p4.name.gsub(/ /,"_").downcase)})
p5.master.images.create!({:attachment => image(p5.name.gsub(/ /,"_").downcase)})

12.times do |mo|
  o1 = v3.orders.create(customer_id: c6.id, ship_address_id: c6.ship_address_id, bill_address_id: c6.ship_address_id, email: c6.email,
    delivery_date: Time.zone.local(2015, mo + 1, 28), user_id: u6.id, created_by_id: u6.id, account_id: a6.id)

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
  o1.payments.create(payment_method_id: Spree::PaymentMethod.last.id)
  if o1.delivery_date < Time.current
    o1.state = "complete"
    o1.completed_at = o1.delivery_date
  end
	submit(o1)

	if o1.delivery_date < Time.current
		approve(o1)
		ship(o1)
		receive(o1)
	end
  o1.save
end

12.times do |mo|
  o1 = v3.orders.create(customer_id: c7.id, ship_address_id: c7.ship_address_id, bill_address_id: c7.ship_address_id, email: c7.email,
    delivery_date: Time.zone.local(2015, mo + 1, 28), user_id: u7.id, created_by_id: u7.id, account_id: a7.id)

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
  o1.payments.create(payment_method_id: Spree::PaymentMethod.last.id)
  if o1.delivery_date < Time.current
    o1.state = "complete"
    o1.completed_at = o1.delivery_date
  end
	submit(o1)

	if o1.delivery_date < Time.current
		approve(o1)
		ship(o1)
		receive(o1)
	end
  o1.save
end

12.times do |mo|
  o1 = v3.orders.create(customer_id: c8.id, ship_address_id: c8.ship_address_id, bill_address_id: c8.ship_address_id, email: c8.email,
    delivery_date: Time.zone.local(2015, mo + 1, 28), user_id: u8.id, created_by_id: u8.id, account_id: a8.id)

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
  o1.payments.create(payment_method_id: Spree::PaymentMethod.last.id)
  if o1.delivery_date < Time.current
    o1.state = "complete"
    o1.completed_at = o1.delivery_date
  end
	submit(o1)

	if o1.delivery_date < Time.current
		approve(o1)
		ship(o1)
		receive(o1)
	end
  o1.save
end

12.times do |mo|
  o1 = v3.orders.create(customer_id: c9.id, ship_address_id: c9.ship_address_id, bill_address_id: c9.ship_address_id, email: c9.email,
    delivery_date: Time.zone.local(2015, mo + 1, 28), user_id: u9.id, created_by_id: u9.id, account_id: a9.id)
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
  o1.payments.create(payment_method_id: Spree::PaymentMethod.last.id)
  if o1.delivery_date < Time.current
    o1.state = "complete"
    o1.completed_at = o1.delivery_date
  end
	submit(o1)

	if o1.delivery_date < Time.current
		approve(o1)
		ship(o1)
		receive(o1)
	end
  o1.save

end

12.times do |mo|
  o1 = v3.orders.create(customer_id: c10.id, ship_address_id: c10.ship_address_id, bill_address_id: c10.ship_address_id, email: c10.email,
    delivery_date: Time.zone.local(2015, mo + 1, 28), user_id: u10.id, created_by_id: u10.id, account_id: a10.id)

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
  o1.payments.create(payment_method_id: Spree::PaymentMethod.last.id)
  if o1.delivery_date < Time.current
    o1.state = "complete"
    o1.completed_at = o1.delivery_date
  end
	submit(o1)

	if o1.delivery_date < Time.current
		approve(o1)
		ship(o1)
		receive(o1)
	end
  o1.save
end

###############################################################################
# Vendor 4 - Chikalicious :Products, Variants, Orders > Li
###############################################################################
a6 = v4.accounts.create(payment_terms: 30, customer_id: c6.id, number: rand(1000000...10000000).to_s)
a7 = v4.accounts.create(payment_terms: 15, customer_id: c7.id, number: rand(1000000...10000000).to_s)
a8 = v4.accounts.create(payment_terms: 15, customer_id: c8.id, number: rand(1000000...10000000).to_s)
a9 = v4.accounts.create(payment_terms: 15, customer_id: c9.id, number: rand(1000000...10000000).to_s)
a10 = v4.accounts.create(payment_terms: 15, customer_id: c10.id, number: rand(1000000...10000000).to_s)

p1 = v4.products.create(name: "Jackson Pollock Salted Caramel Macaroon", price: 2.50, shipping_category_id: 1, available_on: available_date,
  description: "The coolest looking and most delicious macaron in the East Village!", pack_size: "Each")
p2 = v4.products.create(name: "Cookies", price: 4.00, shipping_category_id: 1, available_on: available_date,
  description: "Some of the best cookies in Manhattan!", pack_size: "Each")
p3 = v4.products.create(name: "Vanilla Crepe Cake", price: 59.95, shipping_category_id: 1, available_on: available_date,
  description: "Layers of thin crepes with a vanilla mousse", pack_size: "Each")
p4 = v4.products.create(name: "Green tea Crepe Cake", price: 59.95, shipping_category_id: 1, available_on: available_date,
  description: "Layers of thin crepes with a green tea mousse", pack_size: "Each")
p5 = v4.products.create(name: "Puff Chika Creme Puff", price: 2.95, shipping_category_id: 1, available_on: available_date,
  description: "Stunning cream puff", pack_size: "Each")
p6 = v4.products.create(name: "Cookie Eclair", price: 5.50, shipping_category_id: 1, available_on: available_date,
  description: "An eclair, but crunchy with a delectable creamy filling", pack_size: "Each")
p7 = v4.products.create(name: "Dough'ssant", price: 5.00, shipping_category_id: 1, available_on: available_date,
  description: "Is this the original croissant-doughnut hybrid? It is most certainly worth trying all the flavors!", pack_size: "Each")


  p1.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
  p2.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
  p3.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
  p4.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
  p5.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
  p6.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
  p7.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)

  var1 = p1.master
  var2 = p2.master
  var3 = p3.master
  var4 = p4.master
  var5 = p5.master
  var6 = p6.master
  var7 = p7.master

var1.stock_items.create(stock_location_id: sl4.id)
var2.stock_items.create(stock_location_id: sl4.id)
var3.stock_items.create(stock_location_id: sl4.id)
var4.stock_items.create(stock_location_id: sl4.id)
var5.stock_items.create(stock_location_id: sl4.id)
var6.stock_items.create(stock_location_id: sl4.id)
var7.stock_items.create(stock_location_id: sl4.id)

p1.master.images.create!({:attachment => image(p1.name.gsub(/ /,"_").downcase)})
p2.master.images.create!({:attachment => image(p2.name.gsub(/ /,"_").downcase)})
p3.master.images.create!({:attachment => image(p3.name.gsub(/ /,"_").downcase)})
p4.master.images.create!({:attachment => image(p4.name.gsub(/ /,"_").downcase)})
p5.master.images.create!({:attachment => image(p5.name.gsub(/ /,"_").downcase)})
p6.master.images.create!({:attachment => image(p6.name.gsub(/ /,"_").downcase)})
p7.master.images.create!({:attachment => image(p7.name.gsub(/ /,"_").downcase)})

12.times do |mo|
  o1 = v4.orders.create(customer_id: c6.id, ship_address_id: c6.ship_address_id, bill_address_id: c6.ship_address_id, email: c6.email,
    delivery_date: Time.zone.local(2015, mo + 1, 28), user_id: u6.id, created_by_id: u6.id, account_id: a6.id)

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
  o1.payments.create(payment_method_id: Spree::PaymentMethod.last.id)
  if o1.delivery_date < Time.current
    o1.state = "complete"
    o1.completed_at = o1.delivery_date
  end
	submit(o1)

	if o1.delivery_date < Time.current
		approve(o1)
		ship(o1)
		receive(o1)
	end
  o1.save
end

12.times do |mo|
  o1 = v4.orders.create(customer_id: c7.id, ship_address_id: c7.ship_address_id, bill_address_id: c7.ship_address_id, email: c7.email,
    delivery_date: Time.zone.local(2015, mo + 1, 28), user_id: u7.id, created_by_id: u7.id, account_id: a7.id)

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
  o1.payments.create(payment_method_id: Spree::PaymentMethod.last.id)
  if o1.delivery_date < Time.current
    o1.state = "complete"
    o1.completed_at = o1.delivery_date
  end
	submit(o1)

	if o1.delivery_date < Time.current
		approve(o1)
		ship(o1)
		receive(o1)
	end
  o1.save
end

12.times do |mo|
  o1 = v4.orders.create(customer_id: c8.id, ship_address_id: c8.ship_address_id, bill_address_id: c8.ship_address_id, email: c8.email,
    delivery_date: Time.zone.local(2015, mo + 1, 28), user_id: u8.id, created_by_id: u8.id, account_id: a8.id)

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
  o1.payments.create(payment_method_id: Spree::PaymentMethod.last.id)
  if o1.delivery_date < Time.current
    o1.state = "complete"
    o1.completed_at = o1.delivery_date
  end
	submit(o1)

	if o1.delivery_date < Time.current
		approve(o1)
		ship(o1)
		receive(o1)
	end
  o1.save
end

12.times do |mo|
  o1 = v4.orders.create(customer_id: c9.id, ship_address_id: c9.ship_address_id, bill_address_id: c9.ship_address_id, email: c9.email,
    delivery_date: Time.zone.local(2015, mo + 1, 28), user_id: u9.id, created_by_id: u9.id, account_id: a9.id)

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
  o1.payments.create(payment_method_id: Spree::PaymentMethod.last.id)
  if o1.delivery_date < Time.current
    o1.state = "complete"
    o1.completed_at = o1.delivery_date
  end
	submit(o1)

	if o1.delivery_date < Time.current
		approve(o1)
		ship(o1)
		receive(o1)
	end
  o1.save
end

12.times do |mo|
  o1 = v4.orders.create(customer_id: c10.id, ship_address_id: c10.ship_address_id, bill_address_id: c10.ship_address_id, email: c10.email,
    delivery_date: Time.zone.local(2015, mo + 1, 28), user_id: u10.id, created_by_id: u10.id, account_id: a10.id)

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
  o1.payments.create(payment_method_id: Spree::PaymentMethod.last.id)
  if o1.delivery_date < Time.current
    o1.state = "complete"
    o1.completed_at = o1.delivery_date
  end
	submit(o1)

	if o1.delivery_date < Time.current
		approve(o1)
		ship(o1)
		receive(o1)
	end
  o1.save
end

###############################################################################
# Vendor 5 - Pain D'Avignon :Products, Variants, Orders > Li
###############################################################################
a6 = v5.accounts.create(payment_terms: 30, customer_id: c6.id, number: rand(1000000...10000000).to_s)
a7 = v5.accounts.create(payment_terms: 15, customer_id: c7.id, number: rand(1000000...10000000).to_s)
a8 = v5.accounts.create(payment_terms: 15, customer_id: c8.id, number: rand(1000000...10000000).to_s)
a9 = v5.accounts.create(payment_terms: 15, customer_id: c9.id, number: rand(1000000...10000000).to_s)
a10 = v5.accounts.create(payment_terms: 15, customer_id: c10.id, number: rand(1000000...10000000).to_s)

p1 = v5.products.create(name: "Hamburger Buns", price: 6.00, shipping_category_id: 1, available_on: available_date,
  description: "Very soft, with a thin, bubbly crust which locks in juicy burgers and sauces, and a light, regular crumb, with a mild saltiness.", pack_size: "Each")
p2 = v5.products.create(name: "Specialty Loaves", price: 7.25, shipping_category_id: 1, available_on: available_date,
  description: "In addition to the many standard shapes and sizes, we offer special holiday loaves, and special events loaves (such as 6-foot sandwich bread.) If you have a special event or need bread for a special showcase or breadbasket, contact us and we’ll see how we can help you.", pack_size: "Each")
p3 = v5.products.create(name: "Raisin Pecan", price: 6.00, shipping_category_id: 1, available_on: available_date,
  description: "A regular dense and moist crumb full of raisins and pecans, slightly sweet, baked to a dark crusty brown.", pack_size: "Each")
p4 = v5.products.create(name: "Picholine Olive", price: 5.50, shipping_category_id: 1, available_on: available_date,
  description: "A soft, open, airy crumb, filled with picholine olives and a little bit of fresh rosemary, matched with a soft, bubbly crust with just a bit of crunch.", pack_size: "Each")
p5 = v5.products.create(name: "White French", price: 4.50, shipping_category_id: 1, available_on: available_date,
  description: "A light white loaf made for slicing, similar to the White French Baguette in flavor, but with a denser, more regular crumb and a crust which crackles.", pack_size: "Each")
p6 = v5.products.create(name: "Honey Whole Wheat", price: 4.50, shipping_category_id: 1, available_on: available_date,
  description: "A light whole wheat loaf made for slicing, with a dense, regular crumb ideal for sandwiches, a slight wheat flavor and a very light crust.", pack_size: "Each")
p7 = v5.products.create(name: "Somun", price: 3.50, shipping_category_id: 1, available_on: available_date,
  description: "A soft and light crumb and crust, very spongy, with a touch of olive oil.", pack_size: "Each")
p8 = v5.products.create(name: "Sourdough", price: 4.00, shipping_category_id: 1, available_on: available_date,
  description: "All white-flour sourdough bread with very thin but durable crust, baked to a rich golden brown, a light semi-regular crumb and a pleasantly sour taste and smell.", pack_size: "Each")
p9 = v5.products.create(name: "Pane Francese", price: 5, shipping_category_id: 1, available_on: available_date,
  description: "Similar to ciabatta, but made with sourdough starter, a very open, moist irregular crumb, very soft, almost waxy, and a slightly thicker crust, baked to a dark-golden brown. A slightly sour and salty taste.", pack_size: "Each")
p10 = v5.products.create(name: "Kalamata Olive", price: 6.50, shipping_category_id: 1, available_on: available_date,
  description: "A light, colorful crumb, speckled with kalamata olives and a floured, golden, crust. This bread smells deeply of the olives, and the subtle sourness they impart on the bread.", pack_size: "Each")

  p1.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
  p2.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
  p3.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
  p4.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
  p5.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
  p6.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
  p7.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
  p8.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
  p9.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)
  p10.master.update(sku: rand(10000000...100000000), is_master: true, track_inventory: false, tax_category_id: 1)

  var1 = p1.master
  var2 = p2.master
  var3 = p3.master
  var4 = p4.master
  var5 = p5.master
  var6 = p6.master
  var7 = p7.master
  var8 = p8.master
  var9 = p9.master
  var10 = p10.master

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

p1.master.images.create!({:attachment => image(p1.name.gsub(/ /,"_").downcase)})
p2.master.images.create!({:attachment => image(p2.name.gsub(/ /,"_").downcase)})
p3.master.images.create!({:attachment => image(p3.name.gsub(/ /,"_").downcase)})
p4.master.images.create!({:attachment => image(p4.name.gsub(/ /,"_").downcase)})
p5.master.images.create!({:attachment => image(p5.name.gsub(/ /,"_").downcase)})
p6.master.images.create!({:attachment => image(p6.name.gsub(/ /,"_").downcase)})
p7.master.images.create!({:attachment => image(p7.name.gsub(/ /,"_").downcase)})
p8.master.images.create!({:attachment => image(p8.name.gsub(/ /,"_").downcase)})
p9.master.images.create!({:attachment => image(p9.name.gsub(/ /,"_").downcase)})
p10.master.images.create!({:attachment => image(p10.name.gsub(/ /,"_").downcase)})

12.times do |mo|
  o1 = v5.orders.create(customer_id: c6.id, ship_address_id: c6.ship_address_id, bill_address_id: c6.ship_address_id, email: c6.email,
    delivery_date: Time.zone.local(2015, mo + 1, 28), user_id: u6.id, created_by_id: u6.id, account_id: a6.id)
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
  o1.payments.create(payment_method_id: Spree::PaymentMethod.last.id)
  if o1.delivery_date < Time.current
    o1.state = "complete"
    o1.completed_at = o1.delivery_date
  end
	submit(o1)

	if o1.delivery_date < Time.current
		approve(o1)
		ship(o1)
		receive(o1)
	end
  o1.save
end


12.times do |mo|
  o1 = v5.orders.create(customer_id: c7.id, ship_address_id: c7.ship_address_id, bill_address_id: c7.ship_address_id, email: c7.email,
    delivery_date: Time.zone.local(2015, mo + 1, 28), user_id: u7.id, created_by_id: u7.id, account_id: a7.id)

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
    o1.payments.create(payment_method_id: Spree::PaymentMethod.last.id)
    if o1.delivery_date < Time.current
      o1.state = "complete"
      o1.completed_at = o1.delivery_date
    end
		submit(o1)

		if o1.delivery_date < Time.current
			approve(o1)
			ship(o1)
			receive(o1)
		end
    o1.save
end

12.times do |mo|
  o1 = v5.orders.create(customer_id: c8.id, ship_address_id: c8.ship_address_id, bill_address_id: c8.ship_address_id, email: c8.email,
    delivery_date: Time.zone.local(2015, mo + 1, 28), user_id: u8.id, created_by_id: u8.id, account_id: a8.id)

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
    o1.payments.create(payment_method_id: Spree::PaymentMethod.last.id)
    if o1.delivery_date < Time.current
      o1.state = "complete"
      o1.completed_at = o1.delivery_date
    end
		submit(o1)

		if o1.delivery_date < Time.current
			approve(o1)
			ship(o1)
			receive(o1)
		end
    o1.save
end

12.times do |mo|
  o1 = v5.orders.create(customer_id: c9.id, ship_address_id: c9.ship_address_id, bill_address_id: c9.ship_address_id, email: c9.email,
    delivery_date: Time.zone.local(2015, mo + 1, 28), user_id: u9.id, created_by_id: u9.id, account_id: a9.id)

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
    o1.payments.create(payment_method_id: Spree::PaymentMethod.last.id)
    if o1.delivery_date < Time.current
      o1.state = "complete"
      o1.completed_at = o1.delivery_date
    end
		submit(o1)

		if o1.delivery_date < Time.current
			approve(o1)
			ship(o1)
			receive(o1)
		end
    o1.save
end

12.times do |mo|
  o1 = v5.orders.create(customer_id: c10.id, ship_address_id: c10.ship_address_id, bill_address_id: c10.ship_address_id, email: c10.email,
    delivery_date: Time.zone.local(2015, mo + 1, 28), user_id: u10.id, created_by_id: u10.id, account_id: a10.id)

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
    o1.payments.create(payment_method_id: Spree::PaymentMethod.last.id)
    if o1.delivery_date < Time.current
      o1.state = "complete"
      o1.completed_at = o1.delivery_date
    end
		submit(o1)

		if o1.delivery_date < Time.current
			approve(o1)
			ship(o1)
			receive(o1)
		end

    o1.save
end
