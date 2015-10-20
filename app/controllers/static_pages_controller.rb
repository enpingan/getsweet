class StaticPagesController < ApplicationController
  before_action :require_not_logged_in

  def root
  end

  private

  def require_not_logged_in
    if current_spree_user
      if spree_current_user.has_spree_role?("customer")
        redirect_to '/vendors'
      elsif spree_current_user.has_spree_role?("vendor")
        redirect_to '/manage'
      elsif spree_current_user.has_spree_role?("admin")
        redirect_to '/admin'
      end
    end
  end

end
