Spree::Product.class_eval do
  belongs_to :vendor, class_name: 'Vendor', foreign_key: :vendor_id, primary_key: :id
  accepts_nested_attributes_for :variants, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :master

  delegate_belongs_to :master, :lead_time
end
