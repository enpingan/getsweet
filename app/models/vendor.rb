# == Schema Information
#
# Table name: vendors
#
#  id                :integer          not null, primary key
#  name              :string           not null
#  order_cutoff_time :datetime         not null
#  delivery_minimum  :decimal(, )      default(0.0)
#  payment_terms     :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class Vendor < ActiveRecord::Base
  validates :name, :order_cutoff_time, :delivery_minimum, presence: true

  has_many :users, class_name: 'Spree::User', foreign_key: :vendor_id, primary_key: :id
  has_many :products, class_name: 'Spree::Product', foreign_key: :vendor_id, primary_key: :id
  has_many :orders, class_name: 'Spree::Order', foreign_key: :vendor_id, primary_key: :id
  has_many :spree_roles, through: :users, foreign_key: :vendor_id
  has_many :invoices
  has_many :customers
  has_one :address

end
