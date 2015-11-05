Rails.application.routes.draw do

  # root 'alchemy/pages#show'
  root to: 'static_pages#root'

  mount Spree::Core::Engine, at: '/'

  #devise_scope :spree_user do
  #  delete '/logout', to: 'spree/user_sessions#destroy'
  #end

  # mount Alchemy::Engine, at: '/'

	Spree::Core::Engine.add_routes do

	 scope module: 'cust' do

		resource :account, to: 'customers', only: [:show, :edit, :update]

    resources :vendors, only: [:index, :show] do
      resources :products, only: [:index, :show]
    end
    resources :orders
    resources :orders, :except => [:index, :new, :create, :destroy] do
      post :populate, :on => :collection
      get :unpopulate, to: 'orders#unpopulate'
      get '/success', to: 'orders#success'
    end

    populate_redirect = redirect do |params, request|
      request.flash[:error] = Spree.t(:populate_get_error)
      request.referer || '/cart'
    end

    get '/orders/populate', :to => populate_redirect


    resources :products do
      resources :variants
    end

	 end

 		namespace :manage do
 			#resources :vendors, only: [:index, :show] do

			resource :account, to: 'vendors', only: [:show, :edit, :update]

      resources :customers do
				resources :ship_addresses
			end

    		resources :orders
				resources :orders, :except => [:index, :new, :create, :destroy] do
					post :populate, :on => :collection
          get :unpopulate, to: 'orders#unpopulate'
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

			# get '/', to: 'root#index'#, as: :admin
      get '/', to: 'root#overview'
		end

		namespace :admin do
      get '/search/customers', to: "search#customers", as: :search_customers

	    resources :customers do
 	    	collection do
  	      get :search
      	end

      resources :orders do
        member do
          patch :delivery_update
        end
      end
=begin
      	resources :customer_images do
        	collection do
          	post :update_positions
        	end
      	end

      	resources :customer_logos do
        	collection do
        		post :update_positions
        	end
      	end
=end
			end

	    resources :vendors do
 	    	collection do
  	      get :search
      	end
=begin
      	resources :vendor_images do
        	collection do
          	post :update_positions
        	end
      	end

      	resources :vendor_logos do
        	collection do
        		post :update_positions
        	end
      	end
=end
			end

		end

	end
end
