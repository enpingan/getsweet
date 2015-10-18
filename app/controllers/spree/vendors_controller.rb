module Spree

  class VendorsController < ApplicationController
    def index
      @vendors = Vendor.all
      render :index
    end

    def show
      @vendor = Vendor.friendly.find(params[:id])
      @products = @vendor.products
    end
  end
end
