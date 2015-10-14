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

class Customer < ActiveRecord::Base
  validates :name, :account_id, presence: true
  validates :account_id, uniqueness: true

  has_many :users, class_name: 'Spree::User', foreign_key: :customer_id, primary_key: :id
  has_many :orders, class_name: 'Spree::Order', foreign_key: :customer_id, primary_key: :id

  has_many :spree_roles, through: :users, foreign_key: :customer_id
end
