Spree::Order.class_eval do
  # validates :vendor_id, :customer_id, :user_id, :delivery_date, presence: true
  belongs_to :vendor, class_name: 'Vendor', foreign_key: :vendor_id, primary_key: :id
  belongs_to :customer, class_name: 'Customer', foreign_key: :customer_id, primary_key: :id
  belongs_to :account, class_name: 'Spree::Account', foreign_key: :account_id, primary_key: :id
  has_many :notes, class_name: 'Spree::Note', foreign_key: :order_id, primary_key: :id
  accepts_nested_attributes_for :notes
  # , reject_if: proc { |attributes| attributes['body'].blank? }, allow

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

  ### OVERRIDE OF BASE SPREE finalize! CALL ###
  # Finalizes an in progress order after checkout is complete.
  # Called after transition to complete state
  def finalize!
    # lock all adjustments (coupon promotions, etc.)
    all_adjustments.each{|a| a.close}

    # update payment and shipment(s) states, and save
    #updater.update_payment_state
    shipments.each do |shipment|
      shipment.update!(self)
      shipment.finalize!
    end

    updater.update_shipment_state
    save!
    updater.run_hooks

    touch :completed_at

    deliver_internal_order_confirmation
    deliver_vendor_confirmation unless confirmation_delivered?
    deliver_order_confirmation_email unless confirmation_delivered?

    consider_risk
  end

  def send_cancel_email
    Spree::OrderMailer.cancel_email(self.id).deliver
    Spree::OrderMailer.internal_cancellation_notice(self.id).deliver
  end

  def deliver_vendor_confirmation
    Spree::VendorMailer.confirm_email(self.id).deliver
  end

  def deliver_internal_order_confirmation
    if true # later add a boolean value for whether store wants to be informed
      Spree::OrderMailer.internal_confirmation(self.id).deliver
    end
  end

end
