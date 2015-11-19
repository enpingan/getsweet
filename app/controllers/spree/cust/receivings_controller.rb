module Spree
  module Cust
    class ReceivingsController < Spree::Cust::CustomerHomeController

      before_action :clear_current_order

      def index
        @orders = current_customer.orders.where('delivery_date >= ? AND state = ?', Time.current.to_date, 'complete').order('delivery_date ASC')
        render :index
      end

      def show
      end

      def edit
        @order = Spree::Order.friendly.find(params[:order_id])

        render :edit
      end

      def update
        @order = Spree::Order.friendly.find(params[:order_id])
        if params[:commit] == 'Reject Order'
          @order.line_items.each do |line_item|
            line_item.received_qty = 0
            line_item.confirm_received = false
          end
          @order.save!
          redirect_to receivings_url
        elsif @order.update(receiving_params)
          redirect_to receivings_url
        else
          flash[:errors] = @order.errors.full_messages
          render :edit
        end
      end

      private

      def receiving_params
        params.require(:order).permit(
            line_items_attributes: [:id, :confirm_received, :received_qty]
          )
      end
    end
  end
end
