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
end
