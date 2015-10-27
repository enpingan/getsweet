module Spree

  class VendorsController < Spree::CustomerHomeController
    before_action :authorize_customer, only: [:show]
    def index
      @vendors = Vendor.all
      render :index
    end

    def show
      @vendor = Vendor.friendly.find(params[:id])
      @products = @vendor.products
      @recent_orders = current_customer.orders.where('delivery_date > ? AND vendor_id = ?', 3.months.ago, @vendor.id)
      # @products = @vendor.products.select {|product| product.promotional == true}
    end
  end
end
