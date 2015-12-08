class VendorMailerPreview < ActionMailer::Preview
	
	def confirm_email
		#@order=Spree::Order.find_by(number:'R708628927')
		#@order=Spree::Order.last
		#@orders=Spree::Order.where(state:"complete")
		#@order = @orders.last
		@order=Spree::Order.find_by(number:'R706921225')
		Spree::VendorMailer.confirm_email(@order, true)
	end

	def cancel_email
		#@order=Spree::Order.find_by(number:'R708628927')
		#@order=Spree::Order.last
		#@orders=Spree::Order.where(state:"complete")
		#@order = @orders.last
		@order=Spree::Order.find_by(number:'R706921225')
		Spree::VendorMailer.cancel_email(@order)
	end

end

