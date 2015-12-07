module Spree
 module Cust
  class OrdersController < Spree::Cust::CustomerHomeController
    respond_to :js
    helper_method :sort_column, :sort_direction
    skip_before_action :verify_authenticity_token

    before_action :authorize_customer
    before_action :ensure_customer, only: [:show, :edit, :update, :destroy]

    def index
      clear_current_order
      @customer = current_customer
      @vendors = @customer.vendors.order('name ASC')

      @orders = filter_orders
      @current_vendor_id = session[:vendor_id]
      @start_date = session[:orders_start_date]
      @end_date = session[:orders_end_date]
      @status = session[:orders_filter_status]

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

      if params[:sort] && params[:sort] == 'name'
  			@line_items = Spree::LineItem.where('order_id = ?', @order.id).includes(:product).order(sort_column + ' ' + sort_direction).references(:spree_products)
  		else
  			@line_items = Spree::LineItem.where('order_id = ?', @order.id).order(sort_column + ' ' + sort_direction)
  		end

      # if @order.delivery_date > DateTime.tomorrow.in_time_zone ||(@order.delivery_date == DateTime.tomorrow.in_time_zone && Time.current < @order.vendor.order_cutoff_time.in_time_zone)
      if !@order.any_variant_past_cutoff?
        redirect_to edit_order_url(@order) unless @order.state == "complete"
      else
        render :show
      end
    end

    def new
      clear_current_order
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
      associate_account(@order)

      if @order.save
        set_order_session(@order)
        flash[:success] = "You've started a new order!"
        redirect_to vendor_products_url(@order.vendor)
      else
        flash[:errors] = @order.errors.full_messages
        render :new
      end
    end

    def edit
      @order = set_order_session
      @vendor = @order.vendor

      if params[:sort] && params[:sort] == 'name'
  			@line_items = Spree::LineItem.where('order_id = ?', @order.id).includes(:product).order(sort_column + ' ' + sort_direction).references(:spree_products)
  		else
  			@line_items = Spree::LineItem.where('order_id = ?', @order.id).order(sort_column + ' ' + sort_direction)
  		end

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
          @order.approved = false
          @order.completed_at = Time.current
          @order.user_id = current_spree_user.id

        elsif (params[:commit] == "Add Item" && @order.update(order_params))
          @order.update!
          zero_qty_items = @order.line_items.each do |line_item|
    				line_item.destroy! if line_item.quantity == 0
    			end
          redirect_to vendor_products_url(@order.vendor) and return
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
          format.js { flash.now[:success] = "#{variant.product.name} has been added to your order"}
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
  		redirect_to orders_url
    end

    protected

    def order_params
      params.require(:order).permit(:delivery_date, :vendor_id, :user_id, :item_count,
        :ship_address_id, :bill_address_id, :created_by_id, :state, :completed_at,
        line_items_attributes: [:quantity, :id],
        notes_attributes: [:body, :id])
    end

    def ensure_customer
      @order = Spree::Order.friendly.find(params[:id])
      redirect_to root_url unless current_customer.id == @order.customer_id
    end

    def associate_user(order)
      order.user_id = current_spree_user.id
      order.ship_address_id = current_spree_user.customer.ship_address_id
      order.bill_address_id = current_spree_user.customer.ship_address_id
      order.created_by_id = current_spree_user.id
    end

    def associate_account(order)
      order.account_id = current_customer.accounts.where('vendor_id = ?', order.vendor_id).limit(1).first.id
    end

    def filter_orders

      @current_vendor_id = session[:vendor_id]

      if (params[:vendor] && params[:vendor][:id] == 'all')
        session[:vendor_id] = nil
        @current_vendor_id = nil
      elsif (params[:vendor] && @customer.vendors.collect(&:id).include?(params[:vendor][:id].to_i))
  			@current_vendor_id = params[:vendor][:id]
  			session[:vendor_id] = @current_vendor_id
  	  end

      if @current_vendor_id
  			@orders = @customer.orders.where('vendor_id = ?', @current_vendor_id)
  		else
  			@orders = @customer.orders
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
  			elsif status_type == 'order' && status_name == 'approval required'
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
        elsif params[:sort] == "spree_vendor.name"
          params[:sort]
        else
          "delivery_date"
        end
      elsif params[:action] == 'edit' || params[:action] == 'show'
        if Spree::LineItem.column_names.include?(params[:sort]) || params[:sort] == 'name'
          params[:sort]
        else
          'updated_at'
        end
      end
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
    end

  end
 end
end
