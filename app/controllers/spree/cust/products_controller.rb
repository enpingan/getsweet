module Spree
 module Cust
  class ProductsController < Spree::Cust::CustomerHomeController
    before_action :authorize_customer

    def index
      #@vendor = Spree::Vendor.friendly.find(params[:vendor_id])
      #@products = @vendor.products
      @products = Spree::Product.all
      @vendor = Spree::Vendor.first
      render :index
    end

    def show
      @product = Spree::Product.friendly.find(params[:id])

      @vendor = Vendor.friendly.find(params[:vendor_id])
      # @current_order = current_customer.orders.where('vendor_id = ?', @vendor.id).last
      session[:vendor_id] = @vendor.id
      @current_order = current_order

      render :show
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


  end
 end
end
