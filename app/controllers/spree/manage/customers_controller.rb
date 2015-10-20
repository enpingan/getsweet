module Spree
  module Manage

    class CustomersController < Spree::Manage::BaseController

      def index
        # This is just temporary until the customers are connected to the vendor
        # @customers = Spree::Customer.all
        @vendor = current_spree_user.vendor
        @customers = @vendor.customers
      end

      def show
        @customer = Spree::Customer.find(params[:id])
        render :show
      end


			# 10/21 - KNOWN ISSUE PREVENTING CREATION OF NEW CUSTOMER FROM VENDOR MANAGE PORTAL
			# https://trello.com/c/YOpuCQuQ/16-manage-customers-new-functionality-does-not-work-no-route-matches-post
      def new
        @customer = Spree::Customer.new

				country_id = Address.default.country.id
        @customer.build_ship_address(country_id: country_id) if @customer.ship_address.nil?
        @customer.ship_address.country_id = country_id if @customer.ship_address.country.nil?

			  respond_to do |format|
      		format.html # new.html.erb
      		format.json { render json: @customer }
  			end
      end

      def create
        @customer = Spree::Customer.create(customer_params[:customer])

        if @customer.save
          redirect_to manage_customers_url(@customer)
        else
          render :new
        end
      end

      def edit
        @customer = Spree::Customer.find(params[:id])

				country_id = Address.default.country.id
				@customer.build_ship_address(country_id: country_id) if @customer.ship_address.nil?
				@customer.ship_address.country_id = country_id if @customer.ship_address.country.nil?

        render :edit
      end

      def update
        @customer = Spree::Customer.find(params[:id])

        if @customer.update(customer_params)
          redirect_to manage_customer_url(@customer)
        else
          render :edit
        end
      end

      def destroy
      end


			protected

				def customer_params
    			params.require(:customer).permit(
						:name, 
						:account_id, 
						ship_address_attributes: [ :id, :firstname, :lastname, :phone, :address1, :address2, :city, :country_id, :state_name, :zipcode, :state_id  ])
  			end
    end

  end
end
