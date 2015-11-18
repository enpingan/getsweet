module Spree
 module Cust
  class VendorsController < Spree::Cust::CustomerHomeController

    def index
      clear_current_order
      @customer = current_customer
      @my_vendors = @customer.vendors.order('name ASC')
      @vendors = Vendor.all
      render :index
    end

    def show
      @customer = current_customer
      @vendor = set_current_vendor
      @account = @vendor.accounts.where('customer_id = ?', current_customer.id).limit(1).first
      @recent_orders = @account.orders.order('delivery_date DESC').limit(5)
      @account.balance = @account.orders.where('delivery_date > ?', 30.days.ago).sum('total')
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
