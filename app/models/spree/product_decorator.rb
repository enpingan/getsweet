Spree::Product.class_eval do
  belongs_to :vendor, class_name: 'Vendor', foreign_key: :vendor_id, primary_key: :id
  accepts_nested_attributes_for :variants
  accepts_nested_attributes_for :master
  accepts_nested_attributes_for :variants_including_master, :reject_if => :all_blank, :allow_destroy => true
end
