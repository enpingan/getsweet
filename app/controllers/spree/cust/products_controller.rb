module Spree
 module Cust
  class ProductsController < Spree::Cust::CustomerHomeController
    helper_method :sort_column, :sort_direction
    before_action :authorize_customer

    def index
      @vendor = set_current_vendor
      ensure_vendor_order_match
      @current_order = current_order
      @line_items = @current_order.line_items if @current_order

      if params[:sort] && params[:sort] == 'price'
        @products = sort_direction == 'asc' ? @vendor.products.ascend_by_master_price : @vendor.products.descend_by_master_price
      else
        @products = @vendor.products.order(sort_column + ' ' + sort_direction)
      end

      @recent_orders = current_customer.orders.where('vendor_id = ?', @vendor.id).order('updated_at DESC').order('delivery_date DESC').limit(5)

      render :index
    end

    def show
      @product = Spree::Product.friendly.find(params[:id])
      @variants_including_master = [@product.master] + @product.variants
      @vendor = set_current_vendor
      ensure_vendor_order_match
      @current_order = current_order
      render :show
    end

    private

    def set_current_vendor
      @vendor = Vendor.friendly.find(params[:vendor_id])
      session[:vendor_id] = @vendor.id
      @vendor
    end

    def sort_column
      (Spree::Product.column_names.include?(params[:sort]) || params[:sort] == 'price') ? params[:sort] : "name"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
    end

    def ensure_vendor_order_match
      unless current_order && current_vendor && current_order.vendor_id == current_vendor.id
        clear_current_order
      end
    end

  end
 end
end
