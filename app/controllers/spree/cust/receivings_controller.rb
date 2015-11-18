module Spree
  module Cust
    class ReceivingsController < Spree::Cust::CustomerHomeController

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
      end

    end
  end
end
