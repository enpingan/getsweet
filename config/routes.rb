Rails.application.routes.draw do

  # root 'alchemy/pages#show'

  mount Spree::Core::Engine, at: '/'

  #devise_scope :spree_user do
  #  delete '/logout', to: 'spree/user_sessions#destroy'
  #end

  # mount Alchemy::Engine, at: '/'

	Spree::Core::Engine.add_routes do
    resources :vendors, only: [:index, :show] do
      resources :products, only: [:index, :show]
    end
    resources :orders

 		namespace :manage do
 			#resources :vendors, only: [:index, :show] do
    		resources :orders
				resources :orders, :except => [:index, :new, :create, :destroy] do
					post :populate, :on => :collection
  			end 	
			
				populate_redirect = redirect do |params, request|
			  	request.flash[:error] = Spree.t(:populate_get_error)
    			request.referer || '/cart'
  			end 

  			get '/orders/populate', :to => populate_redirect
    		
				resources :products do
    		  resources :variants
    		end
  		#end

			get '/', to: 'root#index'#, as: :admin

		end

	end
end
