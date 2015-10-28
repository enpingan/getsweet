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
      render :show
    end
  end
 end
end
