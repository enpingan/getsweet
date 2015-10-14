Spree::Order.class_eval do
  belongs_to :vendor, class_name: 'Vendor', foreign_key: :vendor_id, primary_key: :id
  belongs_to :customer, class_name: 'Customer', foreign_key: :customer_id, primary_key: :id
end
