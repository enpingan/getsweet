class ShipmentMailerPreview < ActionMailer::Preview

	def shipped_email
		#shipment = Spree::Shipment.find_by(number:'H57105882857')
		shipment = Spree::Shipment.find_by(number:'H51832754334')
		Spree::ShipmentMailer.shipped_email(shipment)
	end

	def completed_email
		#shipment = Spree::Shipment.find_by(number:'H57105882857')
		shipment = Spree::Shipment.find_by(number:'H51832754334')
		Spree::ShipmentMailer.completed_email(shipment)
	end

end
