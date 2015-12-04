module Spree
	module Manage

class OrdersController < Spree::Manage::BaseController
	helper_method :sort_column, :sort_direction
	respond_to :js

	before_action :ensure_vendor, only: [:show, :edit, :update, :destroy]

  def index
		clear_current_order
		@vendor = current_vendor
		@customers = @vendor.customers.order('name ASC')
		@orders = filter_orders

		@current_customer_id = session[:customer_id]
		@status = session[:orders_filter_status]
		@start_date = session[:orders_start_date]
		@end_date = session[:orders_end_date]
		if params[:sort] && params[:sort] == 'spree_customer.name'
			@orders = @orders.includes(:customer).order('name '+ sort_direction).references(:spree_customers)
		else
			@orders = @orders.order(sort_column + ' ' + sort_direction)
		end

    render :index
  end

	def approve_orders
		@vendor = current_vendor
		@orders = current_vendor.orders

		if @vendor.update(approve_params)
			approved_count = 0
			@orders.each do |order|
				if order.approved && order.approved_at.nil?
					approve_order(order)
					approved_count += 1
				end
			end
			flash[:success] = "#{approved_count} new orders approved!"
		end

		redirect_to manage_orders_url
	end

  def new
		if session[:customer_id]
			@current_customer_id = session[:customer_id]
		end
		@customers = current_vendor.customers
		@order = current_vendor.orders.new
		clear_current_order
		render :new
  end

  def create
		@customers = current_vendor.customers
    @order = current_vendor.orders.new(order_params)

		if @order.customer.users.count == 0
			flash[:error] = "You cannont create an order for a customer with no users."
			render :new and return
		else
			associate_user(@order)
			associate_account(@order)

	    if @order.save!
				set_order_session(@order)
				flash[:success] = "You've started a new order!"
	      redirect_to manage_products_url
	    else
	      flash[:errors] = @order.errors.full_messages
	      render :new
	    end
		end
  end

  def show
    @order = set_order_session
		@vendor = @order.vendor ? @order.vendor : Spree::Vendor.first
    render :show
  end

  def edit
		@order = set_order_session
		if params[:sort] && params[:sort] == 'name'
			@line_items = Spree::LineItem.where('order_id = ?', @order.id).includes(:product).order(sort_column + ' ' + sort_direction).references(:spree_products)
		else
			@line_items = Spree::LineItem.where('order_id = ?', @order.id).order(sort_column + ' ' + sort_direction)
		end
		# @line_items = @order.line_items.order(sort_column + ' ' + sort_direction).references(:spree_line_items)
		@customer = @order.customer
		@vendor = current_vendor
		render :edit
  end

	def update
		@order = set_order_session

		@order.item_count = @order.line_items.sum(:quantity)
		if (params[:commit] == "Approve Order")
			approve_order(@order)
		end

		if @order.update(order_params)
			@order.line_items.each do |line_item|
				if line_item.quantity == 0
					line_item.destroy!
				else
					# line_item.shipped_qty = line_item.quantity
					# # line_item.received_qty = line_item.shipped_qty
					# line_item.shipped_total = line_item.shipped_qty * line_item.price
				end
			end
			@order.update!
			@order.save!

			if params[:commit] == "Add Item"
				redirect_to manage_products_url
			elsif params[:commit] == "Approve Order"
				flash[:success] = "Order Approved!"
				redirect_to manage_orders_url
			else
				flash[:success] = "Your order has been successfully updated!"
				redirect_to edit_manage_order_url(@order)
			end
		else
			flash[:success] = nil
			flash[:errors] = @order.errors.full_messages
			render :edit
		end
	end

  # Adds a new item to the order (creating a new order if none already exists)
  def populate
		order = current_order
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
		order = current_order
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
		@order = set_order_session
		if @order.state == 'complete'
			@order.state = 'canceled'
			@order.canceled_at = Time.current
			@order.canceler_id = current_spree_user.id
			@order.save!
			# send email to vendor
		else
			if @order.destroy
				clear_current_order
				flash[:success] = "Order ##{@order.number} has been canceled"
			else
				flash[:errors] = @order.errors.full_messages
			end
		end
		redirect_to manage_orders_url
  end

  protected

  def order_params
    params.require(:order).permit(:customer_id, :delivery_date, :item_count, :user_id, :state, :completed_at,
			line_items_attributes: [:quantity, :id],
			notes_attributes: [:body, :id])
  end

	def approve_params
		params.require(:vendor).permit(:id,
			orders_attributes: [:approved, :id]
		)
	end

	def ensure_vendor
    @order = Spree::Order.friendly.find(params[:id])
    unless current_vendor.id == @order.vendor_id
			flash[:error] = "You don't have permission to view the requested page"
			redirect_to root_url
		end
  end

	def associate_user(order)
		order.user_id = order.customer.users.first.id
		order.ship_address_id = order.customer.ship_address_id
		order.bill_address_id = order.customer.ship_address_id
		order.created_by_id = order.user_id
	end

	def associate_account(order)
		order.account_id = current_vendor.accounts.where('customer_id = ?', order.customer_id).limit(1).first.id
	end

	def approve_order(order)
		order.state = "complete"
		order.completed_at = Time.current
		order.approver_id = current_spree_user.id
		order.approved_at = Time.current
		order.approved = true
		order.user_id = order.customer.users.first.id unless order.user_id
		unless current_vendor.stock_locations.count > 0
			current_vendor.stock_locations.create(name: current_vendor.name)
		end
		shipment = order.shipments.create(stock_location_id: current_vendor.stock_locations.first.id)
		order.line_items.each do |line_item|
			shipment.inventory_units.create(
				order_id: order.id,
				line_item_id: line_item.id,
				variant_id: line_item.variant_id
			)
		end
		shipment.shipping_rates.create(shipping_method_id: Spree::ShippingMethod.first.id)
		shipment.state = 'ready'
		order.shipment_state = 'ready'
		order.save!
	end

	def filter_orders

		@current_customer_id = session[:customer_id]

	  if (params[:customer] && params[:customer][:id] == 'all')
			session[:customer_id] = nil
			@current_customer_id = nil
		elsif (params[:customer] && @vendor.customers.collect(&:id).include?(params[:customer][:id].to_i))
			@current_customer_id = params[:customer][:id]
			session[:customer_id] = @current_customer_id
		end

	  if @current_customer_id
			@orders = @vendor.orders.where('customer_id = ?', @current_customer_id)
		else
			@orders = @vendor.orders
		end

		if !(params[:start_date].blank? && params[:end_date].blank?)
			session[:orders_start_date], session[:orders_end_date] = params[:start_date], params[:end_date]
			@orders = @orders.where('delivery_date BETWEEN ? AND ?', params[:start_date], params[:end_date])
		elsif (params[:start_date] && params[:start_date].empty? && params[:end_date] && params[:end_date].empty?)
			session[:orders_start_date], session[:orders_end_date] = nil, nil
		elsif !(session[:orders_start_date].blank? && session[:orders_end_date].blank?)
			@orders = @orders.where('delivery_date BETWEEN ? AND ?', session[:orders_start_date], session[:orders_end_date])
		end

		if params[:status]
			status = params[:status].split('-')
			session[:orders_filter_status] = params[:status]
			status_type, status_name = status.first, status.last
			if status_type == 'order' && status_name == 'approved'
				@orders = @orders.where('approved = ?', true)
			elsif status_type == 'order' && status_name == 'action required'
					@orders = @orders.where('approved = ?', false)
			elsif status_type == 'order'
				@orders = @orders.where('state = ?', status_name)
			elsif status_type == 'shipment'
				@orders = @orders.where('shipment_state = ?', status_name)
			end
		else
			session[:orders_filter_status] = nil
		end

		@orders
	end


	def sort_column
		if params[:action] == 'index'
			if Spree::Order.column_names.include?(params[:sort])
				params[:sort]
			elsif params[:sort] == "spree_customer.name"
				params[:sort]
			else
				"delivery_date"
			end
		elsif params[:action] == 'edit'
			if Spree::LineItem.column_names.include?(params[:sort]) || params[:sort] == 'name'
				params[:sort]
			else
				'updated_at'
			end
		end
	end

	def sort_direction
		%w[asc desc].include?(params[:direction]) ?  params[:direction] : "DESC"
	end
end



	# /. Vendor
	end
# /. Spree
end
