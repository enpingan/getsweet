Spree::LineItem.class_eval do
  has_one :vendor, through: :order

  def is_past_cutoff?
    ((Time.current.to_date + self.variant.lead_time.day) > self.order.delivery_date) || (Time.current > self.vendor.order_cutoff_time.in_time_zone && ((Time.current.to_date + self.variant.lead_time.day) == self.order.delivery_date))
  end
end
