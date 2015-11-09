module Spree
 module Cust
  class VendorsController < Spree::Cust::CustomerHomeController
    helper_method :sort_column, :sort_direction
    before_action :authorize_customer, only: [:show]
    def index
      @vendors = Vendor.all
      render :index
    end

    def show
      @vendor = Vendor.friendly.find(params[:id])
      # @current_order = current_customer.orders.where('vendor_id = ?', @vendor.id).last
      session[:vendor_id] = @vendor.id
      @current_order = current_order

      @line_items = @current_order.line_items if @current_order

      if params[:sort] && params[:sort] == 'price'
        @products = sort_direction == 'asc' ? @vendor.products.ascend_by_master_price : @vendor.products.descend_by_master_price
      else
        @products = @vendor.products.order(sort_column + ' ' + sort_direction)
      end

      @recent_orders = current_customer.orders.where('vendor_id = ?', @vendor.id).order('updated_at DESC').order('delivery_date DESC').limit(5)

    end

    private

    def current_order
      if session[:order_id]
        @current_order = Spree::Order.find(session[:order_id])
        return nil unless @current_order.vendor.id == current_vendor.id
      end
      @current_order
    end

    def current_vendor
      if session[:vendor_id]
        @current_vendor = Spree::Vendor.find(session[:vendor_id])
      end
        @current_vendor
    end

    def sort_column
      (Spree::Product.column_names.include?(params[:sort]) || params[:sort] == 'price') ? params[:sort] : "name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
    end

  end
 end
end
