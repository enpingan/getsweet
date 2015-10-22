# == Schema Information
#
# Table name: customers
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  account_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module Spree
	#class Customer < ActiveRecord::Base
	class Customer < Spree::Base
	  validates :name, :account_id, presence: true
	  validates :account_id, uniqueness: true

	  has_many :users, class_name: 'Spree::User', foreign_key: :customer_id, primary_key: :id
	  has_many :orders, class_name: 'Spree::Order', foreign_key: :customer_id, primary_key: :id

	  has_many :spree_roles, through: :users, foreign_key: :customer_id

    belongs_to :ship_address, foreign_key: :ship_address_id, class_name: 'Spree::Address'
    alias_attribute :shipping_address, :ship_address
		accepts_nested_attributes_for :ship_address

		#has_many :addresses, class_name: 'Spree::Address', foreign_key: :address_id, primary_key: :id
	end
end
