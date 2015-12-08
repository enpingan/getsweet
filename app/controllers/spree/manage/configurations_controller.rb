module Spree
  module Manage
    class ConfigurationsController < Spree::BaseController
      include Spree::Core::ControllerHelpers::Order

      layout '/spree/layouts/manage'
      helper 'spree/manage/navigation'
      helper 'spree/manage/tables'

      before_action :authorize_vendor

      def index 

      end

      def integration

      end

      protected
        def authorize_vendor
          if current_spree_user.nil?
          flash[:error] = "You must be logged in"
          redirect_to root_url
          elsif !current_spree_user.has_spree_role?('vendor')
          flash[:error] = "You do not have permission to view the page requested"
          redirect_to root_url
          end
        end
		end
	end
end
