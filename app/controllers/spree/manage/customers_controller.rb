module Spree
  module Manage

    class CustomersController < Spree::Manage::BaseController

      def index
        # This is just temporary until the customers are connected to the vendor
        @customers = Spree::Customer.all
      end

      def show
        @customer = Spree::Customer.find(params[:id])
        @address = @customer.addresses.first
        render :show
      end

      def new
        @customer = Spree::Customer.new
      end

      def create
        @customer = Spree::Customer.new(customer_params)
        # @customer.vendor = current_spree_user.vendor

        if @customer.save
          redirect_to manage_customer_url(customer)
        else
          render :new
        end
      end

      def edit
        @customer = Spree::Customer.find(params[:id])
        render :edit
      end

      def update
        @customer = Spree::Customer.find(params[:id])

        if @customer.update(customer_params)
          redirect_to manage_customer_url(customer)
        else
          render :edit
        end
      end

      def destroy
      end

    end

  end
end
