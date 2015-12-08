class IntegrationItem < ActiveRecord::Base

	def self.register_token(item_title, token, secret, realm_id)
		item = IntegrationItem.find_by_item_title(item_title)

		if !item.nil?
			item.app_token = token
			item.consumer_secret = secret
			item.consumer_key = realm_id
			item.configured = true
			item.save
		end
	end	

end
