Rails.application.routes.draw do

  # root 'alchemy/pages#show'

  mount Spree::Core::Engine, at: '/'

  #devise_scope :spree_user do
  #  delete '/logout', to: 'spree/user_sessions#destroy'
  #end

  # mount Alchemy::Engine, at: '/'

	Spree::Core::Engine.add_routes do
 		namespace :manage do
 			#resources :vendors, only: [:index, :show] do
    		resources :orders
    		resources :products do
    		  resources :variants
    		end
  		#end
		end
	end
end
