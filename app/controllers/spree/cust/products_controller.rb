module Spree
 module Cust
  class ProductsController < Spree::Cust::CustomerHomeController
    before_action :authorize_customer

    def index
      #@vendor = Spree::Vendor.friendly.find(params[:vendor_id])
      #@products = @vendor.products
      @products = Spree::Product.all
      @vendor = @products.first.vendor
      render :index
    end

    def show
      @product = Spree::Product.friendly.find(params[:id])

      @vendor = @product.vendor
      session[:vendor_id] = @vendor.id
      @current_order = current_order
      render :show
    end

    private


  end
 end
end
