module Spree
  module Manage


		class VendorsController < Spree::Manage::BaseController
      before_action :clear_current_order

		  def index
		    @vendors = Spree::Vendor.all
		    render :index
		  end

		  def show
 		   	#@account = Spree::Vendor.friendly.find(params[:id])
    	  @account = spree_current_user.vendor
				#@products = @account.products.order('name DESC')
 			end

			def edit
    	  @account = spree_current_user.vendor

        session[:vendor_id] = @account.id
        render :edit
			end

			def update
	      @account = spree_current_user.vendor
	      session[:vendor_id] = @account.id
	      if @account.update(account_params)
 	      	flash[:success] = "Account has been updated!"
 	      	redirect_to manage_account_url
	      else
	        flash[:errors] = @account.errors.full_messages
	        render :edit
 	    	end
			end

      protected

        def account_params
          params.require(:vendor).permit(
            :name,
            :email,
            :order_cutoff_time,
						:delivery_minimum,
						:payment_terms)
        end

		end

  # /. Vendor
  end
# /. Spree
end
