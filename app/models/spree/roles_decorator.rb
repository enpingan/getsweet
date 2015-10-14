Spree::Role.class_eval do
  has_many :vendors, through: :users, foreign_key: :vendor_id
  has_many :customers, through: :users, foreign_key: :customer_id
end
