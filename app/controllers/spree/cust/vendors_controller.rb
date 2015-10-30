module Spree
 module Cust
  class VendorsController < Spree::Cust::CustomerHomeController
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
      @products = @vendor.products
      # @recent_orders = current_customer.orders.where('delivery_date > ? AND vendor_id = ?', 3.months.ago, @vendor.id)
      @recent_orders = current_customer.orders.where('vendor_id = ?', @vendor.id).order('updated_at DESC').order('delivery_date DESC').limit(5)
      # @products = @vendor.products.select {|product| product.promotional == true}
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
        @current_vendor = Spree::Customer.find(session[:vendor_id])
      end
        @current_vendor
    end

  end
 end
end
