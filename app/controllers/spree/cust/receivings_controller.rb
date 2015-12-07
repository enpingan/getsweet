module Spree
  module Cust
    class ReceivingsController < Spree::Cust::CustomerHomeController

      before_action :clear_current_order

      def index
        # @orders = current_customer.orders.where('state = ?', 'complete').order('delivery_date ASC')
        @shipments = current_customer.shipments.where('received_at IS NULL OR received_at > ?', 1.months.ago)
        render :index
      end

      def edit
        # @order = Spree::Order.friendly.find(params[:order_id])
        @shipment = Spree::Shipment.friendly.find(params[:id])
        @order = @shipment.order

        render :edit
      end

      def update
        # @order = Spree::Order.friendly.find(params[:order_id])
        @shipment = Spree::Shipment.friendly.find(params[:id])
        @order = @shipment.order

        @shipment.receiver_id = current_spree_user.id
        @shipment.received_at = Time.current

        if params[:commit] == 'Reject Order'
          @shipment.line_items.each do |line_item|
            line_item.received_qty = 0
            line_item.confirm_received = false
          end
          @shipment.receive
          @order.save!
          redirect_to receivings_url
        elsif params[:order][:line_items_attributes].none? {|li, attrs| attrs[:confirm_received] == '1'} #checks that at least one item has been received
          flash.now[:error] = "You must mark the items that you received!"
          render :edit
        elsif @order.update(receiving_params)
          @order.line_items.each do |line_item|
            line_item.received_qty = 0 unless line_item.received_qty && line_item.confirm_received
            line_item.received_total = line_item.received_qty * line_item.price
          end
          @shipment.receive
          @order.save!
          redirect_to receivings_url
        else
          flash[:errors] = @order.errors.full_messages
          render :edit
        end
      end

      private

      def receiving_params
        params.require(:order).permit(
            line_items_attributes: [:id, :confirm_received, :received_qty],
            notes_attributes: [:id, :body]
          )
      end
    end
  end
end
