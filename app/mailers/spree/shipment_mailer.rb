module Spree
  class ShipmentMailer < BaseMailer
    def shipped_email(shipment, resend = false)
      send_email( shipment )
    end

    def completed_email(shipment, resend = false)
      send_email( shipment )
    end

    private

    def send_email shipment
      @shipment = shipment.respond_to?(:id) ? shipment : Spree::Shipment.find(shipment)
      @order = @shipment.order
      subject = "#{Spree.t('order_mailer.confirm_email.subject')} #{@order.vendor.name} (##{@order.number})"
      mail(to: @shipment.order.email, from: from_address, subject: subject)
    end

  end
end
