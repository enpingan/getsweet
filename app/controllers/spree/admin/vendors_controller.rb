module Spree
  module Admin
    class VendorsController < ResourceController


      def index
        respond_with(@collection) do |format|
          format.html
          format.json { render :json => json_data }
        end 
      end 

      def show
        redirect_to edit_admin_vendor_path(@vendor)
      end 

      def create

        @vendor = Spree.vendor_class.new(vendor_params)
        if @vendor.save

          flash.now[:success] = flash_message_for(@vendor, :successfully_created)
          render :edit
        else
          render :new
        end 
      end 

      def update
        if @vendor.update_attributes(vendor_params)
          flash.now[:success] = Spree.t(:account_updated)
        end 

        render :edit
      end 

			protected

			private

      def vendor_params
        params.require(:vendor).permit(permitted_vendor_attributes #|
                                     #[:spree_role_ids,
                                      #ship_address_attributes: permitted_address_attributes,
                                      #bill_address_attributes: permitted_address_attributes]
				)
      end
		end
	end
end
