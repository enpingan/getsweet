module Spree
  class OrdersController < ApplicationController
    before_action :authorize_customer

    def index
      @orders = Spree::Order.all
      # @orders = Customer.find(current_spree_user.customer_id).orders
      render :index
    end

    def show
      @order = Spree::Order.friendly.find(params[:id])
      render :show
    end

    def new
    end

    def create
    end

    def edit
      @order = Spree::Order.friendly.find(params[:id])

    end

    def update
      @order = Spree::Order.friendly.find(params[:id])

      if @order.update(order_params)
        redirect_to orders_url
      else
        render :edit
      end
    end

    def destroy
    end

    protected

    def order_params
      params.require(:order).permit()
    end
  end
end
