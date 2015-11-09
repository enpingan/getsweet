Spree::UserSessionsController.class_eval do

  def new
    redirect_to '/'
  end

  def create
    flash[:errors] = "Invalid Email/Password Combination!"
    redirect_to '/'
  end

  def after_sign_in_path_for(resource)
    if spree_current_user.has_spree_role?("admin")
      admin_path
    elsif spree_current_user.has_spree_role?("vendor")
      manage_url
    elsif spree_current_user.has_spree_role?("customer")
      vendors_url
    else
      '/'
    end
  end

  def logout

  end

end
