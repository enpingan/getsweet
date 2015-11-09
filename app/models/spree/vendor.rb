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
module Spree
	#class Vendor < ActiveRecord::Base
	class Vendor < Spree::Base
 	 validates :name, :order_cutoff_time, :delivery_minimum, presence: true

	  has_many :users, class_name: 'Spree::User', foreign_key: :vendor_id, primary_key: :id
	  has_many :products, class_name: 'Spree::Product', foreign_key: :vendor_id, primary_key: :id
	  has_many :orders, class_name: 'Spree::Order', foreign_key: :vendor_id, primary_key: :id
	  has_many :spree_roles, through: :users, foreign_key: :vendor_id
	  #has_many :invoices
	  has_and_belongs_to_many :customers, join_table: :spree_customers_vendors
	  has_one :address

		has_many :images, -> { order(:position) }, as: :viewable, dependent: :destroy, class_name: "Spree::VendorImage"


	  extend FriendlyId
			friendly_id :name, use: [:slugged, :finders]
	end
end
