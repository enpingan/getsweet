module Spree
  module Manage
    class RootController < Spree::Manage::BaseController

      #skip_before_filter :authorize_admin

      def index
				# temporarily forwarding to products#index as landing page
        redirect_to manage_root_redirect_path
      end

      def overview
        @vendor = current_vendor
        render :overview
      end

      protected

      def manage_root_redirect_path
        # spree.manage_products_path
        spree.manage_overview_path
      end
    end
  end
end
