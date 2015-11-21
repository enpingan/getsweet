Spree::User.class_eval do
  # Temporarily removing validation of names for seeding admin user
  # validates :firstname, :lastname, presence: true

  belongs_to :vendor, class_name: 'Vendor', foreign_key: :vendor_id, primary_key: :id
  belongs_to :customer, class_name: 'Customer', foreign_key: :customer_id, primary_key: :id
  has_many :notes, class_name: 'Spree::Notes', foreign_key: :user_id, primary_key: :id

	has_many :images, as: :viewable, dependent: :destroy, class_name: "Spree::UserImage"
end
