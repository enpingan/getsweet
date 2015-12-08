class OrderMailerPreview < ActionMailer::Preview
	
	def confirm_email
		#@order=Spree::Order.find_by(number:'R708628927')
		#@order=Spree::Order.last
		#@orders=Spree::Order.where(state:"complete")
    #@order = @orders.last
		@order=Spree::Order.find_by(number:'R706921225')
		Spree::OrderMailer.confirm_email(@order)
	end

	def internal_confirmation
		#@order=Spree::Order.find_by(number:'R708628927')
		#@order=Spree::Order.last
		#@orders=Spree::Order.where(state:"complete")
    #@order = @orders.last
		@order=Spree::Order.find_by(number:'R706921225')
		Spree::OrderMailer.internal_confirmation(@order)
	end

	def cancel_email
		#@order=Spree::Order.find_by(number:'R708628927')
		#@orders=Spree::Order.where(state:"canceled")
		#@order=@orders.last
		@order=Spree::Order.find_by(number:'R810416292')
		Spree::OrderMailer.cancel_email(@order)
	end

	def internal_cancellation_notice
		#@order=Spree::Order.find_by(number:'R708628927')
		#@orders=Spree::Order.where(state:"canceled")
		#@order=@orders.last
		@order=Spree::Order.find_by(number:'R706921225')
		Spree::OrderMailer.internal_cancellation_notice(@order)
	end

end

