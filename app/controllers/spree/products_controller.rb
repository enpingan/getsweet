module Spree
  class ProductsController < ApplicationController
    def index
      @vendor = Vendor.find(params[:vendor_id])
      @products = @vendor.products
      render :index
    end

    def show
      @product = Spree::Product.find(params[:id])
      render :show
    end
  end
end
