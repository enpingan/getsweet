# == Schema Information
#
# Table name: spree_customers
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  account_id      :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  ship_address_id :integer
#  email           :string
#

module Spree
	#class Customer < ActiveRecord::Base
	class Customer < Spree::Base

	  has_many :users, class_name: 'Spree::User', foreign_key: :customer_id, primary_key: :id
		has_many :admins, class_name: 'Spree::User', foreign_key: :customer_id, primary_key: :id
	  has_many :orders, class_name: 'Spree::Order', foreign_key: :customer_id, primary_key: :id

	  has_many :spree_roles, through: :users, foreign_key: :customer_id

    belongs_to :ship_address, foreign_key: :ship_address_id, class_name: 'Spree::Address'
    alias_attribute :shipping_address, :ship_address

		# has_and_belongs_to_many :vendors, join_table: :spree_customers_vendors
		has_many :accounts, class_name: 'Spree::Account', foreign_key: :customer_id, primary_key: :id
		has_many :vendors, through: :accounts, foreign_key: :customer_id

		has_many :shipments, through: :orders

		has_many :images, -> { order(:position) }, as: :viewable, dependent: :destroy, class_name: "Spree::CustomerImage"
		accepts_nested_attributes_for :ship_address

	end
end
