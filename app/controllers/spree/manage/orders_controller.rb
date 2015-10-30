module Spree
	module Manage

class OrdersController < Spree::Manage::BaseController

	respond_to :js

	before_action :ensure_vendor, only: [:show, :edit, :update, :destroy]

  def index
		@vendor = current_vendor
		@orders = @vendor.orders
    render :index
  end

  def new
		if session[:customer_id]
			@current_customer_id = session[:customer_id]
		end
		@customers = current_vendor.customers
		@order = current_vendor.orders.new
  end

  def create
		@customers = current_vendor.customers
    @order = current_vendor.orders.new(order_params)

    if @order.save!
			set_order_session(@order)
			flash[:success] = "You've started a new order!"
      redirect_to manage_products_url
    else
      flash[:errors] = @order.errors.full_messages
      render :new
    end
  end

  def show
    @order = set_order_session
		@vendor = @order.vendor ? @order.vendor : Spree::Vendor.first
    render :show
  end

  def edit
		@order = set_order_session
		@vendor = current_vendor
		render :edit
  end

	def update
		@order = set_order_session


		if request.patch?
			if (params[:commit] == Spree.t(:update))
				flash[:success] = "Your order has been successfully update!"
			elsif (params[:commit] == "Approve Order")
				@order.approver_id = current_spree_user.id
				@order.approved_at = Time.now
				flash[:success] = "Order Approved!"
			elsif (params[:commit] == "Add New Product To Order" && @order.update(order_params))
				redirect_to manage_products_url and return
			end
		end

		if @order.update(order_params)
			redirect_to edit_manage_order_url(@order)
		else
			flash[:success] = nil
			flash[:errors] = @order.errors.full_messages
			render :edit
		end
	end

  # Adds a new item to the order (creating a new order if none already exists)
  def populate

    order    = Spree::Order.find(params[:order]['id'].to_i)
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
    self.params.require(:order).permit(:customer_id, :delivery_date,
			line_items_attributes: [:quantity, :id])
  end

	def ensure_vendor
    @order = Spree::Order.friendly.find(params[:id])
    unless current_vendor.id == @order.vendor_id
			flash[:error] = "You don't have permission to view the requested page"
			redirect_to root_url
		end
  end

	def set_order_session(order = nil)
		order ||= Spree::Order.friendly.find(params[:id])
		session[:order_id] = order.id
		session[:customer_id] = order.customer.id
		order
	end
end


	# /. Vendor
	end
# /. Spree
end
