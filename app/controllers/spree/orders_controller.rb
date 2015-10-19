module Spree
  class OrdersController < ApplicationController
    before_action :authorize_customer
    before_action :ensure_customer, only: [:show, :edit, :update, :destroy]

    def index
      @orders = current_spree_user.orders

      render :index
    end

    def show
      @order = Spree::Order.friendly.find(params[:id])
      render :show
    end

    def new
      @order = current_spree_user.orders.new
    end

    def create
      @order = current_spree_user.orders.new
    end

    def edit
      @order = Spree::Order.friendly.find(params[:id])
      render :edit
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

    def ensure_customer
      @order = Spree::Order.friendly.find(params[:id])
      redirect_to login_url unless current_spree_user.customer_id == @order.customer_id
    end
  end
end
