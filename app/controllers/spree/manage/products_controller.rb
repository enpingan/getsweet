module Spree
  module Manage
	
	
	class ProductsController < ApplicationController
  def index
    #@vendor = Vendor.find(params[:vendor_id])
    #@products = @vendor.products
    @vendor = Vendor.first
    @products = Spree::Product.all
    render :index
  end

  def show
    @product = Spree::Product.find(params[:id])
  end

end


  # /. Vendor
  end 
# /. Spree
end
