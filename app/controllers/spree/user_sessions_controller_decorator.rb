Spree::UserSessionsController.class_eval do

  def after_sign_in_path_for(resource)
    if spree_current_user.has_spree_role?("admin")
      admin_path
    elsif spree_current_user.has_spree_role?("vendor")
      manage_url
    elsif spree_current_user.has_spree_role?("customer")
      vendors_url
    else
      root_path
    end
  end

  def logout
    
  end

end