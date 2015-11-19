module Spree
 module Cust
  class CustomerHomeController < Spree::BaseController
    include Spree::Core::ControllerHelpers::Order

    layout '/spree/layouts/customer'

    protected

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
      session[:order_id] ? Spree::Order.find(session[:order_id]) : nil
    end

    def current_vendor
      if session[:vendor_id]
        @current_vendor = Spree::Vendor.find(session[:vendor_id])
      end
        @current_vendor
    end

    def set_order_session(order = nil)
      if params[:order_id]
        order ||= Spree::Order.friendly.find(params[:order_id])
      else
        order ||= Spree::Order.friendly.find(params[:id])
      end
      session[:order_id] = order.id
      order
    end

    def clear_current_order
      session[:order_id] = nil
    end

    def flash_message_for(object, event_sym)
      resource_desc  = object.class.model_name.human
      resource_desc += " \"#{object.name}\"" if object.respond_to?(:name) && object.name.present?
      Spree.t(event_sym, resource: resource_desc)
    end 

  end
 end
end
