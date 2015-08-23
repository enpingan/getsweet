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
