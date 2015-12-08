module Spree
  class VendorMailer < BaseMailer
  
	  def confirm_email(order, resend = false)
      @order = order.respond_to?(:id) ? order : Spree::Order.find(order)
			@shipment = Spree::Shipment.find_by(order_id:@order.id)
			@shipping_method = @shipment.shipping_method
      subject = (resend ? "[#{Spree.t(:resend)}] " : '') 
      subject += "#{Spree.t('vendor_mailer.confirm_email.subject')} ##{@order.number}"
      mail(to: @order.vendor.email, cc: Spree::Store.current.mail_from_address, from: from_address, subject: subject)
    end 

    def cancel_email(order, resend = false)
      @order = order.respond_to?(:id) ? order : Spree::Order.find(order)
      subject = (resend ? "[#{Spree.t(:resend)}] " : '')
      subject += "#{Spree.t('vendor_mailer.cancel_email.subject')} ##{@order.number}"
      mail(to: @order.vendor.email, cc: Spree::Store.current.mail_from_address, from: from_address, subject: subject)
    end 

  end 
end
