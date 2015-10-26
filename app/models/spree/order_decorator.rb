Spree::Order.class_eval do
  belongs_to :vendor, class_name: 'Vendor', foreign_key: :vendor_id, primary_key: :id
  belongs_to :customer, class_name: 'Customer', foreign_key: :customer_id, primary_key: :id

  checkout_flow do
    go_to_state :address
   # go_to_state :payment
    go_to_state :complete
    remove_transition :from => :delivery, :to => :confirm
    remove_transition :from => :delivery, :to => :confirm
    remove_transition :from => :payment, :to => :confirm
  end
  #Spree::Order.state_machine.before_transition :to => :payment, :do => :set_order

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
