Spree::Product.class_eval do
  belongs_to :vendor, class_name: 'Vendor', foreign_key: :vendor_id, primary_key: :id
  accepts_nested_attributes_for :variants,
    reject_if: proc { |attributes| attributes['sku'].blank? || attributes['pack_size'].blank? || attributes['lead_time'].blank?},
    allow_destroy: true
  accepts_nested_attributes_for :master

  delegate_belongs_to :master, :lead_time
  delegate_belongs_to :master, :pack_size
end
