class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  Spree::PermittedAttributes.user_attributes << :vendor_id
  Spree::PermittedAttributes.user_attributes << :customer_id
	Spree::PermittedAttributes.user_attributes << :firstname
	Spree::PermittedAttributes.user_attributes << :lastname
  Spree::PermittedAttributes.variant_attributes << :pack_size
  Spree::PermittedAttributes.variant_attributes << :lead_time

	include Spree::BaseHelper
	include Spree::Core::ControllerHelpers
  include Spree::Core::ControllerHelpers::Store
  helper Spree::Core::Engine.helpers

end
