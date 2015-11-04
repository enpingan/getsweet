module Spree
	module Manage

class OrdersController < Spree::Manage::BaseController

	respond_to :js

	before_action :ensure_vendor, only: [:show, :edit, :update, :destroy]

  def index
		@current_customer_id = session[:customer_id]
		session[:customer_id] = nil
		@vendor = current_vendor
		# if @current_customer_id
		# 	@orders = @vendor.orders.where('customer_id = ?', @current_customer_id).order('delivery_date DESC')
		# else
		# 	@orders = @vendor.orders.order('delivery_date DESC')
		# end

		if (params[:customer] && @vendor.customers.collect(&:name).include?(params[:customer][:name]))
			@current_customer = Spree::Customer.find_by_name(params[:customer][:name])
			@orders = @vendor.orders.where('customer_id = ?', @current_customer.id).order('delivery_date DESC')
			session[:customer_id] = @current_customer.id
	  else
	     @orders = @vendor.orders.order('delivery_date DESC')
	  end

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
		@order.user_id = @order.customer.users.first.id
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
		@customer = @order.customer
		@vendor = current_vendor
		render :edit
  end

	def update
		@order = set_order_session


		if request.patch?
			@order.item_count = @order.line_items.sum(:quantity)
			if (params[:commit] == Spree.t(:update))
				flash[:success] = "Your order has been successfully update!"
			elsif (params[:commit] == "Approve Order")
				@order.approver_id = current_spree_user.id
				@order.approved_at = Time.now
				@order.user_id = @order.customer.users.first.id unless @order.user_id
				flash[:success] = "Order Approved!"
			elsif (params[:commit] == "Add Item" && @order.update(order_params))
				@order.update!
				redirect_to manage_products_url and return
			end
		end

		if @order.update(order_params)
			@order.line_items.each do |line_item|
				line_item.destroy! if line_item.quantity == 0
			end
			@order.update!
			redirect_to edit_manage_order_url(@order)
		else
			flash[:success] = nil
			flash[:errors] = @order.errors.full_messages
			render :edit
		end
	end

  # Adds a new item to the order (creating a new order if none already exists)
  def populate
		order = Spree::Order.find(session[:order_id])
    # order    = Spree::Order.find(params[:order]['id'].to_i)
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
				format.js { flash.now[:success] = "#{variant.product.name} has been added to your order"}
        # format.html { redirect_to cart_path }
      end
    end
  end

	def unpopulate
		order = Spree::Order.friendly.find(params[:order_id])
		line_item = Spree::LineItem.find(params[:index])
		if line_item.destroy
			order.item_count = order.line_items.sum(:quantity)
			order.update!
			flash[:success] = "Item Removed"
			redirect_to edit_manage_order_url(order)
		else
			render :edit
		end
	end

  def destroy
		@order = Spree::Order.friendly.find(params[:id])
		if @order.destroy
			session[:order_id] = nil;
			flash[:success] = "Order ##{@order.number} has been cancelled"
		else
			flash[:errors] = @order.errors.full_messages
		end
		redirect_to manage_orders_url
  end

  protected

  def order_params
    self.params.require(:order).permit(:customer_id, :delivery_date, :item_count, :user_id,
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
