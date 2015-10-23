module Spree
  class CustomerHomeController < Spree::BaseController



    private

    def action
      params[:action].to_sym
    end

    def authorize_customer
      if current_spree_user.nil? || !current_spree_user.has_spree_role?('customer')
        redirect_to root_url
      end
    end

  end
end
