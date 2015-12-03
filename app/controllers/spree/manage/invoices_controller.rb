module Spree
	module Manage
    class InvoicesController < Spree::Manage::BaseController
			helper_method :sort_column, :sort_direction

			before_action :ensure_vendor, only: [:show, :edit, :update]

      def index
        # @invoices = current_vendor.orders.where('state = ? AND approved_at IS NOT NULL', 'complete').order('delivery_date DESC')


				clear_current_order
				@current_customer_id = session[:customer_id]
				@start_date = session[:invoice_start_date]
				@end_date = session[:invoice_end_date]

				@vendor = current_vendor

				@invoices = filter_invoices
				if params[:sort] && params[:sort] == 'spree_customer.name'
					@invoices = @invoices.includes(:customer).order('name '+ sort_direction).references(:spree_customers)
				else
					@invoices = @invoices.order(sort_column + ' ' + sort_direction)
				end

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

			def ensure_vendor
		    @order = Spree::Order.friendly.find(params[:id])
		    unless current_vendor.id == @order.vendor_id
					flash[:error] = "You don't have permission to view the requested page"
					redirect_to root_url
				end
		  end

			def filter_invoices

				@current_customer_id = session[:customer_id]

				if (params[:customer] && @vendor.customers.collect(&:name).include?(params[:customer][:name]))
					@current_customer_id = Spree::Customer.find_by_name(params[:customer][:name]).id
					session[:customer_id] = @current_customer_id
			  elsif (params[:customer] && params[:customer][:name] == 'all')
					session[:customer_id] = nil
					@current_customer_id = nil
				end

				@invoices = current_vendor.orders.where('state = ? AND approved_at IS NOT NULL', 'complete').order('delivery_date DESC')
			  if @current_customer_id
					@invoices = @invoices.where('customer_id = ?', @current_customer_id)
				end

				unless (params[:start_date].blank? || params[:end_date].blank?)
					session[:invoice_start_date], session[:invoice_end_date] = params[:start_date], params[:end_date]
					@invoices = @invoices.where('delivery_date BETWEEN ? AND ?', params[:start_date], params[:end_date])
				end
				@invoices
			end

			def sort_column
				if params[:action] == 'index'
					if Spree::Order.column_names.include?(params[:sort])
						params[:sort]
					elsif params[:sort] == "spree_customer.name"
						params[:sort]
					else
						"delivery_date"
					end
				elsif params[:action] == 'edit'
					if Spree::LineItem.column_names.include?(params[:sort]) || params[:sort] == 'name'
						params[:sort]
					else
						'updated_at'
					end
				end
			end

			def sort_direction
				%w[asc desc].include?(params[:direction]) ?  params[:direction] : "DESC"
			end


    end
  end
end
