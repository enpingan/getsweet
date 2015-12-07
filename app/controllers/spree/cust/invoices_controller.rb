module Spree
	module Cust
    class InvoicesController < Spree::Cust::CustomerHomeController
			helper_method :sort_column, :sort_direction

      def index
				@customer = current_customer
				@vendors = @customer.vendors.order('name ASC')

				@invoices = filter_invoices

				@current_vendor_id = session[:vendor_id]
				@start_date = session[:invoices_start_date]
				@end_date = session[:invoices_end_date]

				if params[:sort] && params[:sort] == 'spree_vendor.name'
					@invoices = @invoices.includes(:vendor).order('name '+ sort_direction).references(:spree_vendors)
				else
					@invoices = @invoices.order(sort_column + ' ' + sort_direction)
				end

		    render :index
      end

      def show
        @invoice = Spree::Order.friendly.find(params[:id])
        render :show
      end

			private

			def filter_invoices

				@current_vendor_id = session[:vendor_id]

				if (params[:vendor] && params[:vendor][:id] == 'all')
	        session[:vendor_id] = nil
	        @current_vendor_id = nil
	      elsif (params[:vendor] && @customer.vendors.collect(&:id).include?(params[:vendor][:id].to_i))
	  			@current_vendor_id = params[:vendor][:id]
	  			session[:vendor_id] = @current_vendor_id
	  	  end

				# @invoices = current_vendor.orders.where('state = ? AND approved_at IS NOT NULL', 'complete').order('delivery_date DESC')
				@invoices = current_customer.orders.where('shipment_state = ?', 'received')
				if @current_vendor_id
					@invoices = @invoices.where('vendor_id = ?', @current_vendor_id)
				end

				# unless (params[:start_date].blank? || params[:end_date].blank?)
				# 	session[:invoices_start_date], session[:invoices_end_date] = params[:start_date], params[:end_date]
				# 	@invoices = @invoices.where('delivery_date BETWEEN ? AND ?', params[:start_date], params[:end_date])
				# end
				if !(params[:start_date].blank? && params[:end_date].blank?)
					session[:invoices_start_date], session[:invoices_end_date] = params[:start_date], params[:end_date]
					@invoices = @invoices.where('delivery_date BETWEEN ? AND ?', params[:start_date], params[:end_date])
				elsif (params[:start_date] && params[:start_date].empty? && params[:end_date] && params[:end_date].empty?)
					session[:invoices_start_date], session[:invoices_end_date] = nil, nil
				elsif !(session[:invoices_start_date].blank? && session[:invoices_end_date].blank?)
					@invoices = @invoices.where('delivery_date BETWEEN ? AND ?', session[:invoices_start_date], session[:invoices_end_date])
				end
				@invoices
			end

			def sort_column
				if params[:action] == 'index'
					if Spree::Order.column_names.include?(params[:sort])
						params[:sort]
					elsif params[:sort] == "spree_vendor.name"
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
