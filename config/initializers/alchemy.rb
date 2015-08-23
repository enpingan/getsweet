# config/initializers/alchemy.rb

# Tell Alchemy to use the Spree::User class
Alchemy.user_class_name = 'Spree::User'
Alchemy.current_user_method = :spree_current_user

# Load the Spree.user_class decorator for Alchemy roles
require 'alchemy/spree/spree_user_decorator'

# Include the Spree controller helpers to render the
# alchemy pages within the default Spree layout
Alchemy::BaseHelper.send :include, Spree::BaseHelper
Alchemy::BaseController.send :include, Spree::Core::ControllerHelpers::Common
Alchemy::BaseController.send :include, Spree::Core::ControllerHelpers::Store

# Tell Alchemy to use Spree signin, signup, login paths
#Alchemy.signup_path         = '/spree/user_registrations#new'   # Defaults to '/signup'
#Alchemy.login_path          = '/spree/user_sessions#new'    # Defaults to '/login'
#Alchemy.logout_path         = '/spree/user_sessions#destroy'   # Defaults to '/logout'
Alchemy.signup_path         = '/user/spree_user/sign_up'   # Defaults to '/signup'
Alchemy.login_path          = '/user/spree_user/sign_in'    # Defaults to '/login'
Alchemy.logout_path         = '/user/spree_user/logout'   # Defaults to '/logout'
