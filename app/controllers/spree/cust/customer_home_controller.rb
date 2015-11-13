module Spree
 module Cust
  class CustomerHomeController < Spree::BaseController

    layout '/spree/layouts/customer'

    private

    def action
      params[:action].to_sym
    end

    def authorize_customer
      if current_spree_user.nil?
        flash[:error] = "You must be logged in"
        redirect_to root_url
      elsif !current_spree_user.has_spree_role?('customer')
        flash[:error] = "You do not have permission to view the page requested"
        redirect_to root_url
      end
    end

    def current_customer
      current_spree_user.customer
    end

    def current_order
      Spree::Order.first
    end

    def clear_current_order
      session[:order_id] = nil
    end

  end
 end
end
