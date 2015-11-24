Spree::Variant.class_eval do
  # validates :lead_time, :pack_size, presence: true
  accepts_nested_attributes_for :prices, :reject_if => :all_blank, :allow_destroy => true
end
