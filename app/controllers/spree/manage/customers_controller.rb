module Spree
  module Manage

    class CustomersController < Spree::Manage::BaseController

      before_action :ensure_vendor, only: [:show, :edit, :update, :destroy]
      before_action :clear_current_order

      def index

        @vendor = current_vendor
        @customers = @vendor.customers
      end

      def show
				@vendor = current_vendor
        @customer = Spree::Customer.find(params[:id])
        @account = @customer.accounts.where('vendor_id = ?', current_vendor.id).limit(1).first
        session[:customer_id] = @customer.id
        # stub balance for demo
        @balance = @customer.orders.where('delivery_date > ?', 30.days.ago).sum('total')
        render :show
      end

      def new
        @account = current_vendor.accounts.new
        @customer = @account.build_customer
        # @customer = Spree::Customer.new
        #
				country_id = Address.default.country.id
        @customer.build_ship_address(country_id: country_id) if @customer.ship_address.nil?
        @customer.ship_address.country_id = country_id if @customer.ship_address.country.nil?

			  respond_to do |format|
      		format.html # new.html.erb
      		format.json { render json: @customer }
  			end
      end

      def create
        @account = current_vendor.accounts.new(account_params)
        # @customer = current_vendor.customers.new(customer_params)
        c = @account.customer.ship_address

        user = Spree::User.new(firstname: c.firstname,
                               lastname: c.lastname,
                               email: @account.customer.email,
                               phone: c.phone,
                               password: "#{c.firstname}_#{c.lastname}"
          )
          user.spree_roles << Spree::Role.find_by_name('customer')
        if @account.save && user.save
          @account.customer.update!(spree_account_id: 'C' + (1000000 + @account.customer.id).to_s)
          session[:customer_id] = @account.customer.id
          flash[:success] = "Congratulations, a new customer!"
          redirect_to manage_customers_url
        else
          flash[:errors] = @account.errors.full_messages + user.errors.full_messages
          render :new
        end
      end

      def edit
        @customer = Spree::Customer.find(params[:id])
        @account = @customer.accounts.where('vendor_id = ?', current_vendor.id).limit(1).first

				# country_id = Address.default.country.id
				# @customer.build_ship_address(country_id: country_id) if @customer.ship_address.nil?
				# @customer.ship_address.country_id = country_id if @customer.ship_address.country.nil?
        session[:customer_id] = @customer.id
        render :edit
      end

      def update
        @customer = Spree::Customer.find(params[:id])
        @account = @customer.accounts.where('vendor_id = ?', current_vendor.id).limit(1).first
        session[:customer_id] = @customer.id
        if @account.update(account_params)
          flash[:success] = "Customer has been updated!"
          redirect_to manage_customer_url(@customer)
        else
          flash[:errors] = @customer.errors.full_messages
          render :edit
        end
      end

      def destroy
      end

			protected

				def account_params
          params.require(:account).permit(
          :number, :payment_terms, :customer_id, :discount_type, :discount, :cost_price_discount, :balance,
            customer_attributes:
              [
                :id, :name, :email,
                ship_address_attributes:
                  [ :id, :firstname, :lastname, :phone,
                    :address1, :address2, :city, :country_id, :state_name, :zipcode, :state_id
                  ]
              ]
          )


    			# params.require(:customer).permit(
					# 	:name,
					# 	:account_id,
					# 	:email,
					# 	ship_address_attributes: [ :id, :firstname, :lastname, :phone, :address1, :address2, :city, :country_id, :state_name, :zipcode, :state_id  ])
  			end

			private

      	def ensure_vendor
        	@customer = Spree::Customer.find(params[:id])
        	unless @customer.vendors.include?(current_vendor)
            flash[:error] = "You do not have permission to view the page requested"
            redirect_to root_url
          end
      	end

    end

  end
end
