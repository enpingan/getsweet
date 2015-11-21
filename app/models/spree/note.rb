module Spree
	class Note < Spree::Base
    validates :user_id, presence: true

    belongs_to :user, class_name: 'Spree::User', foreign_key: :user_id, primary_key: :id
    belongs_to :order, class_name: 'Spree::Order', foreign_key: :order_id, primary_key: :id

  end
end
