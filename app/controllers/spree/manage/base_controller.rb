module Spree
  module Manage
    class BaseController < Spree::BaseController
 	   include Spree::Core::ControllerHelpers::Order

      layout '/spree/layouts/manage'
      helper 'spree/manage/navigation'
      helper 'spree/manage/tables'

			#before_action :authorize_admin
      before_action :authorize_vendor

			protected
				def action
          params[:action].to_sym
        end

				def authorize_admin
          if respond_to?(:model_class, true) && model_class
            record = model_class
          else
            record = controller_name.to_sym
          end
          authorize! :admin, record
          authorize! action, record
       	end

        def current_vendor
          return nil if current_spree_user.nil?
          current_spree_user.vendor
        end

        def authorize_vendor

          if current_spree_user.nil?
            flash[:error] = "You must be logged in"
            redirect_to root_url
          elsif !current_spree_user.has_spree_role?('vendor')
            flash[:error] = "You do not have permission to view the page requested"
            redirect_to root_url
          end
        end

        def set_order_session(order = nil)
      		order ||= Spree::Order.friendly.find(params[:id])
      		session[:order_id] = order.id
      		session[:customer_id] = order.customer.id
      		order
      	end

      	def current_order
      		session[:order_id] ? Spree::Order.find(session[:order_id]) : nil
      	end

      	def clear_current_order
      		session[:order_id] = nil
      	end


		end
	end
end
