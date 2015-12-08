module Spree
  class OrderMailer < BaseMailer
    def confirm_email(order, resend = false)
      @order = order.respond_to?(:id) ? order : Spree::Order.find(order)
			@shipment = Spree::Shipment.find_by(order_id:@order.id)
			@shipping_method = @shipment.shipping_method
      subject = (resend ? "[#{Spree.t(:resend)}] " : '')
      subject += "#{Spree.t('order_mailer.confirm_email.subject')} #{@order.vendor.name} (##{@order.number})"
      mail(to: @order.email, from: from_address, subject: subject)
    end

    def cancel_email(order, resend = false)
      @order = order.respond_to?(:id) ? order : Spree::Order.find(order)
      subject = (resend ? "[#{Spree.t(:resend)}] " : '')
      subject += "#{Spree.t('order_mailer.cancel_email.subject1')} #{@order.vendor.name} #{Spree.t('order_mailer.cancel_email.subject2')} (##{@order.number})"
      mail(to: @order.email, from: from_address, subject: subject)
    end

    def internal_confirmation(order, resend = false)
      @order = order.respond_to?(:id) ? order : Spree::Order.find(order)
			@shipment = Spree::Shipment.find_by(order_id:@order.id)
			@shipping_method = @shipment.shipping_method
      subject = (resend ? "[#{Spree.t(:resend)}] " : '')
      subject += "#{Spree.t('order_mailer.internal_confirm.subject')} - For #{@order.vendor.name} (##{@order.number})"
      mail(to: Spree::Store.current.mail_from_address, from: from_address, subject: subject)
    end

    def internal_cancellation_notice(order)
      @order = order.respond_to?(:id) ? order : Spree::Order.find(order)
			@shipment = Spree::Shipment.find_by(order_id:@order.id)
      subject = "#{Spree.t('order_mailer.internal_cancel.subject')} - For #{@order.vendor.name} (##{@order.number})"
      mail(to: Spree::Store.current.mail_from_address, from: from_address, subject: subject)
    end

	end
end
