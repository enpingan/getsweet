module Spree
  module Admin
    class CustomersController < ResourceController


      def index
        respond_with(@collection) do |format|
          format.html
          format.json { render :json => json_data }
        end 
      end 

      def show
        redirect_to edit_admin_customer_path(@customer)
      end 

      def create

        @customer = Spree::Customer.new(customer_params)
        if @customer.save

          flash.now[:success] = flash_message_for(@customer, :successfully_created)
          render :edit
        else
          render :new
        end 
      end 

      def update
        if @customer.update_attributes(customer_params)
          flash.now[:success] = Spree.t(:account_updated)
        end 

        render :edit
      end 

			protected

			private

      def customer_params
				params.require(:customer).permit([:name, :account_id])
      end
		end
	end
end
