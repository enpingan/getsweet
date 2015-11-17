module Spree
 module Cust
  class VendorsController < Spree::Cust::CustomerHomeController

    def index
      clear_current_order
      @customer = current_customer
      @vendors = Vendor.all
      render :index
    end

    def show
      @vendor = set_current_vendor
      @recent_orders = current_customer.orders.where('vendor_id = ?', @vendor.id).order('updated_at DESC').order('delivery_date DESC').limit(5)

      render :show
    end

    private

    def set_current_vendor
      @vendor = Vendor.friendly.find(params[:id])
      session[:vendor_id] = @vendor.id
      @vendor
    end

  end
 end
end
