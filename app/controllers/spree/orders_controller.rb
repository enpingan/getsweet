module Spree
  class OrdersController < Spree::CustomerHomeController
    before_action :authorize_customer
    before_action :ensure_customer, only: [:show, :edit, :update, :destroy]

    def index
      @orders = current_customer.orders

      render :index
    end

    def show
      @order = set_order_session
      render :show
    end

    def new
      @order = current_customer.orders.new
    end

    def create
      @order = current_customer.orders.new
    end

    def edit
      @order = set_order_session
      render :edit
    end

    def update
      @order = set_order_session

      if @order.update(order_params)
        redirect_to orders_url
      else
        render :edit
      end
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
      params.require(:order).permit()
    end

    def ensure_customer
      @order = Spree::Order.friendly.find(params[:id])
      redirect_to root_url unless current_customer.id == @order.customer_id
    end

    def set_order_session
      order = Spree::Order.friendly.find(params[:id])
      session[:order_id] = order.id
      order
    end
  end
end
