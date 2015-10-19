module Spree
	module Manage

class OrdersController < Spree::Manage::BaseController
	
	respond_to :js

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
		@vendor = @order.vendor ? @order.vendor : Spree::Vendor.first
    render :show
  end

  def edit

  end

  def update
    @order = Spree::Order.find(params[:id])

  end

  # Adds a new item to the order (creating a new order if none already exists)
  def populate

    order    = current_order(create_order_if_necessary: true)
    variant  = Spree::Variant.find(params[:index])
    quantity = params[:quantity].to_i
    options  = params[:options] || {}

    # 2,147,483,647 is crazy. See issue #2695.
    if quantity.between?(1, 2_147_483_647)
      begin
        order.contents.add(variant, quantity, options)
      rescue ActiveRecord::RecordInvalid => e
        error = e.record.errors.full_messages.join(", ")
      end
    else
      error = Spree.t(:please_enter_reasonable_quantity)
    end

    if error
      flash[:error] = error
      redirect_back_or_default(spree.root_path)
    else
      respond_with(order) do |format|
				format.js
        format.html { redirect_to cart_path }
      end
    end
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
