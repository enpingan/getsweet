Spree::Order.class_eval do
  # validates :vendor_id, :customer_id, :user_id, :delivery_date, presence: true
  belongs_to :vendor, class_name: 'Vendor', foreign_key: :vendor_id, primary_key: :id
  belongs_to :customer, class_name: 'Customer', foreign_key: :customer_id, primary_key: :id

	remove_checkout_step :address
	remove_checkout_step :delivery
	remove_checkout_step :payment

  def set_order
    self.create_proposed_shipments
  end
  def require_email
    return false
  end
  def payment_required?
    false
  end

  def any_variant_past_cutoff?
    self.line_items.any? do |line_item|
      line_item.is_past_cutoff?
      # ((Time.current.to_date + line_item.variant.lead_time.day) > self.delivery_date) || (Time.current > self.vendor.order_cutoff_time.in_time_zone && ((Time.current.to_date + line_item.variant.lead_time.day) == self.delivery_date))
    end
  end

  def all_variants_past_cutoff?
    self.line_items.all? do |line_item|
      line_item.is_past_cutoff?
      # ((Time.current.to_date + line_item.variant.lead_time.day) > self.delivery_date) || (Time.current > self.vendor.order_cutoff_time.in_time_zone && ((Time.current.to_date + line_item.variant.lead_time.day) == self.delivery_date))
    end
  end
end
