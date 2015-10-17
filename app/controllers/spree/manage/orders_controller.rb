module Spree
	module Manage

class OrdersController < ApplicationController
  def index
		# REMOVING VENDOR ID FIND FOR NOW, WILL EVENTUALLY BE BASED ON THE USER WHO IS LOGGED IN SO WE WILL UPDATE THIS WITH THE AUTH COMPONENT
    #@vendor = Vendor.find(params[:vendor_id])
    #@orders = @vendor.orders
    
		# temporary
		@orders = Spree::Order.all
		@vendor = Spree::Vendor.first

    render :index
  end

  def new
  end

  def create
    @order = Spree::Order.new(order_params)

    if @order.save!
      redirect_to :vendor_orders_url
    else
      flash[:errors] = @order.errors.full_messages
      render :new
    end
  end

  def show
    @order = Spree::Order.find_by(number:params[:id])
    render :show
  end

  def edit

  end

  def update
    @order = Spree::Order.find(params[:id])

  end

  def destroy
  end

  protected

  def order_params
    self.params.require(:spree_order).permit(:customer_id) #this makes sense from the vendor side
  end
end


	# /. Vendor
	end
# /. Spree
end
