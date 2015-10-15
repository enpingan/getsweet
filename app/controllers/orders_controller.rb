class OrdersController < ApplicationController
  def index
    @vendor = Vendor.find(params[:vendor_id])
    @orders = @vendor.orders
    render :index
  end

  def show
    @order = Spree::Order.find(params[:id])
    render :show
  end
end
