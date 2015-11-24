module Spree
	module Manage
    class InvoicesController < Spree::Manage::BaseController

      def index
        @invoices = current_vendor.orders.where('state = ? AND approved_at IS NOT NULL', 'complete').order('delivery_date DESC')
        render :index
      end

      def show
        @invoice = Spree::Order.friendly.find(params[:id])
        render :show
      end

      def edit
        @invoice = Spree::Order.friendly.find(params[:id])
				@note = @invoice.notes.new
				session[:return_to] ||= request.referer
        render :edit
      end

      def update

        @invoice = Spree::Order.friendly.find(params[:id])
        if @invoice.update(invoice_params)
          flash[:success] = "Invoice # #{@invoice.number} has been updated."
          redirect_to manage_invoice_url(@invoice)
        else
          flash[:errors] = @invoice.errors.full_messages
          render :edit
        end
      end

      private

      def invoice_params
        params.require(:order).permit(
          :total,
          line_items_attributes: [:id, :received_qty, :received_total],
					notes_attributes: [:id, :body]
        )
      end


    end
  end
end
