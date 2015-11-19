# == Schema Information
#
# Table name: spree_accounts
#
#  id                  :integer          not null, primary key
#  payment_terms       :integer          not null
#  balance             :decimal(, )      default(0.0), not null
#  status              :string
#  discount            :decimal(, )      default(0.0), not null
#  cost_price_discount :decimal(, )      default(0.0), not null
#  discount_type       :string           default("None"), not null
#  customer_id         :integer
#  vendor_id           :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

module Spree
  class Account < Spree::Base
    belongs_to :vendor, class_name: 'Spree::Vendor', foreign_key: :vendor_id, primary_key: :id
    belongs_to :customer, class_name: 'Spree::Customer', foreign_key: :customer_id, primary_key: :id

    has_many :orders, class_name: 'Spree::Order', foreign_key: :account_id, primary_key: :id
    accepts_nested_attributes_for :customer

  end
end
