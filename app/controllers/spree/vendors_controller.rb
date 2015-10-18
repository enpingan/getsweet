module Spree

  class VendorsController < ApplicationController
    def index
      @vendors = Vendor.all
      render :index
    end

    def show
      @vendor = Vendor.friendly.find(params[:id])
      @products = @vendor.products
      # @products = @vendor.products.select {|product| product.promotional == true}
    end
  end
end
