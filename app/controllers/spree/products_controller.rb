module Spree
  class ProductsController < ApplicationController
    def index
      @vendor = Vendor.friendly.find(params[:vendor_id])
      @products = @vendor.products
      render :index
    end

    def show
      @product = Spree::Product.friendly.find(params[:id])
      render :show
    end
  end
end
