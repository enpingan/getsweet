module Spree
 module Cust
  class OrdersController < Spree::Cust::CustomerHomeController
    respond_to :js
    helper_method :sort_column, :sort_direction
    skip_before_action :verify_authenticity_token

    before_action :authorize_customer
    before_action :ensure_customer, only: [:show, :edit, :update, :destroy]

    def index
      @customer = current_customer

      @orders = filter_orders
      if params[:sort] && params[:sort] == 'spree_vendor.name'
        @orders = @orders.includes(:vendor).order('name '+ sort_direction).references(:spree_vendors)
      else
        @orders = @orders.order(sort_column + ' ' + sort_direction)
      end
      render :index
    end

    def show
      @order = set_order_session
      @path = "show"
      if @order.delivery_date > DateTime.tomorrow ||(@order.delivery_date == DateTime.tomorrow && Time.now < @order.vendor.order_cutoff_time.to_datetime)
        redirect_to edit_order_url(@order) unless @order.state == "complete"
      else
        render :show
      end
    end

    def new
      @order = current_customer.orders.new
      @vendors = current_customer.vendors
      if session[:vendor_id]
        @current_vendor_id = session[:vendor_id]
      end
    end

    def create
      @order = current_customer.orders.new(order_params)
      @vendors = current_customer.vendors

      associate_user(@order)

      if @order.save
        set_order_session(@order)
        flash[:success] = "You've started a new order!"
        redirect_to vendor_url(@order.vendor_id)
      else
        flash[:errors] = @order.errors.full_messages
        render :new
      end
    end

    def edit
      @order = set_order_session
      @vendor = @order.vendor
      render :edit
    end

    def update
      @order = set_order_session

      if request.patch?
        @order.item_count = @order.line_items.sum(:quantity)
        if (params[:commit] == Spree.t(:update))
          flash[:success] = "Your order has been successfully update!"
        elsif (params[:commit] == "Submit Order")
					@order.next
          @order.user_id = current_spree_user.id

        elsif (params[:commit] == "Resubmit Order")
          @order.approver_id = nil
  				@order.approved_at = nil
          @order.completed_at = Time.now
          @order.user_id = current_spree_user.id

        elsif (params[:commit] == "Add Item" && @order.update(order_params))
          @order.update!
          zero_qty_items = @order.line_items.each do |line_item|
    				line_item.destroy! if line_item.quantity == 0
    			end
          redirect_to vendor_url(@order.vendor) and return
        end
      end
      if @order.update(order_params)
        zero_qty_items = @order.line_items.each do |line_item|
  				line_item.destroy! if line_item.quantity == 0
  			end
        @order.update!
        if params[:commit] == "Submit Order" || params[:commit] == "Resubmit Order"
          redirect_to order_success_url(@order.id)
        else
          redirect_to order_url(@order)
        end
      else
        flash[:success] = nil
        flash[:errors] = @order.errors.full_messages
        render :edit
      end
    end

    def success
      @order = set_order_session
      render :success
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
          format.html { redirect_to cart_path }
          format.js { flash[:success] = "#{variant.product.name} has been added to your order"}
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
        redirect_to edit_order_url(order)
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
  		redirect_to orders_url
    end

    protected

    def order_params
      params.require(:order).permit(:delivery_date, :vendor_id, :user_id, :item_count,
        :ship_address_id, :bill_address_id, :created_by_id, :state, :completed_at,
        line_items_attributes: [:quantity, :id])
    end

    def ensure_customer
      @order = Spree::Order.friendly.find(params[:id])
      redirect_to root_url unless current_customer.id == @order.customer_id
    end

    def set_order_session(order = nil)
      unless order
        if params[:order_id]
          order = Spree::Order.friendly.find(params[:order_id])
        else
          order = Spree::Order.friendly.find(params[:id])
        end
      end
      session[:order_id] = order.id
      session[:vendor_id] = order.vendor.id
      order
    end

    def associate_user(order)
      order.user_id = current_spree_user.id
      order.ship_address_id = current_spree_user.customer.ship_address_id
      order.bill_address_id = current_spree_user.customer.ship_address_id
      order.created_by_id = current_spree_user.id
    end

    def filter_orders
      @orders = current_customer.orders
      if (params[:vendor] && @customer.vendors.collect(&:name).include?(params[:vendor][:name]))
  			@current_vendor = Spree::Vendor.find_by_name(params[:vendor][:name])
  			@orders = @customer.orders.where('vendor_id = ?', @current_vendor.id)
  			session[:vendor_id] = @current_vendor.id
  	  end

      unless (params[:date].nil? || params[:date].empty?)
  			@orders = @orders.where('delivery_date = ?', params[:date])
  		end
      @orders
    end

    def sort_column
      if Spree::Order.column_names.include?(params[:sort])
        params[:sort]
      elsif params[:sort] == "spree_vendor.name"
        params[:sort]
      else
        "delivery_date"
      end
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
    end

  end
 end
end
