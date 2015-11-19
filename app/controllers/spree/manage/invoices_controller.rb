module Spree
	module Manage
    class InvoicesController < Spree::Manage::BaseController

      def index
        @invoices = current_vendor.orders.where('state = ?', 'complete').order('delivery_date DESC')
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
