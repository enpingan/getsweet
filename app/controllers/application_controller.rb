class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  Spree::PermittedAttributes.user_attributes << :vendor_id
  Spree::PermittedAttributes.user_attributes << :customer_id

	include Spree::BaseHelper
	include Spree::Core::ControllerHelpers
  include Spree::Core::ControllerHelpers::Store
  helper Spree::Core::Engine.helpers

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
