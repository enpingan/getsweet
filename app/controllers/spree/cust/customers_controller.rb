module Spree
 module Cust
  class CustomersController < Spree::Cust::CustomerHomeController
    before_action :authorize_customer, only: [:show, :edit]

		def edit
      @customer = current_customer

        country_id = Address.default.country.id
        @customer.build_ship_address(country_id: country_id) if @customer.ship_address.nil?
        @customer.ship_address.country_id = country_id if @customer.ship_address.country.nil?
        session[:customer_id] = @customer.id
        render :edit
		end

    def show
      @customer = current_customer
      @users = @customer.users.order('firstname ASC')

    end

		def update
      @customer = current_customer
      session[:customer_id] = @customer.id
      if @customer.update(customer_params)
        flash[:success] = "Customer has been updated!"
        redirect_to account_url
      else
        flash[:errors] = @customer.errors.full_messages
        render :edit
      end
		end

      protected

        def customer_params
          params.require(:customer).permit(
            :name,
            :account_id,
						:email,
            ship_address_attributes: [ :id, :firstname, :lastname, :phone, :address1, :address2, :city, :country_id, :state_name, :zipcode, :state_id  ])
        end

    private

  end
 end
end
