module Spree

  class VendorsController < Spree::CustomerHomeController
    before_action :authorize_customer, only: [:show]
    def index
      @vendors = Vendor.all
      render :index
    end

    def show
      @vendor = Vendor.friendly.find(params[:id])
      # @current_order = current_customer.orders.where('vendor_id = ?', @vendor.id).last
      if session[:order_id]
        @current_order = Spree::Order.find(session[:order_id])
      else
        @current_order = @vendor.orders.create(customer_id: current_customer.id, delivery_date: DateTime.tomorrow)
        session[:order_id] = @current_order.id
      end
      @line_items = @current_order.line_items
      @products = @vendor.products
      @recent_orders = current_customer.orders.where('delivery_date > ? AND vendor_id = ?', 3.months.ago, @vendor.id)
      # @products = @vendor.products.select {|product| product.promotional == true}
    end
  end
end
