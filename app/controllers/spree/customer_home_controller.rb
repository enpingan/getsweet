module Spree
  class CustomerHomeController < Spree::BaseController

    layout '/spree/layouts/customer'

    private

    def action
      params[:action].to_sym
    end

    def authorize_customer
      if current_spree_user.nil? || !current_spree_user.has_spree_role?('customer')
        redirect_to root_url
      end
    end

    def current_customer
      current_spree_user.customer
    end

  end
end
