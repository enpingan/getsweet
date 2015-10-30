module Spree
 module Cust
  class OrdersController < Spree::Cust::CustomerHomeController
    respond_to :js

    skip_before_action :verify_authenticity_token

    before_action :authorize_customer
    before_action :ensure_customer, only: [:show, :edit, :update, :destroy]

    def index
      @orders = current_customer.orders

      render :index
    end

    def show
      @order = set_order_session
      @path = "show"
      render :show
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
      render :edit
    end

    def update
      @order = set_order_session

      if @order.update(order_params)
        flash[:success] = "Your order has been successfully update!"
        redirect_to orders_url
      else
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
          #format.js { redirect_to vendor_path(order.vendor) }
          format.js
          format.html { redirect_to cart_path }
        end
      end
    end

    def destroy
    end

    protected

    def order_params
      params.require(:order).permit(:delivery_date, :vendor_id,
        line_items_attributes: [:quantity, :id])
    end

    def ensure_customer
      @order = Spree::Order.friendly.find(params[:id])
      redirect_to root_url unless current_customer.id == @order.customer_id
    end

    def set_order_session(order = nil)
      order ||= Spree::Order.friendly.find(params[:id])
      session[:order_id] = order.id
      session[:vendor_id] = order.vendor.id
      order
    end
  end
 end
end
