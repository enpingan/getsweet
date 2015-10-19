class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

	include Spree::BaseHelper
	include Spree::Core::ControllerHelpers
  include Spree::Core::ControllerHelpers::Store
  helper Spree::Core::Engine.helpers

  private

  def authorize_customer
    if current_spree_user.nil? || !current_spree_user.has_spree_role?('customer')
      redirect_to login_url
    end
  end
end
