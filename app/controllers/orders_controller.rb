class OrdersController < ApplicationController
  def index
    @orders = Vendor.find(params[:vendor_id]).orders
    render :index
  end
end
