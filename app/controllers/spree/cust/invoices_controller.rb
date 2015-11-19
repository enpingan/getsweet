module Spree
	module Cust
    class InvoicesController < Spree::Cust::CustomerHomeController

      def index
        @invoices = current_customer.orders.where('state = ?', 'complete').order('delivery_date DESC')
        render :index
      end

      def show
        @invoice = Spree::Order.friendly.find(params[:id])
        render :show
      end

      def edit
      end

      def update
      end


    end
  end
end
