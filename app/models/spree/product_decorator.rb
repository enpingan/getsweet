Spree::Product.class_eval do
  belongs_to :vendor, class_name: 'Vendor', foreign_key: :vendor_id, primary_key: :id
end
