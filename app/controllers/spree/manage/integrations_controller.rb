module Spree
  module Manage
    class IntegrationsController < Spree::BaseController
      include Spree::Core::ControllerHelpers::Order

      layout '/spree/layouts/manage'
      helper 'spree/manage/navigation'
      helper 'spree/manage/tables'

      before_action :authorize_vendor
      before_action :set_qb_service, only: [:push_info, :pull_info]

      def index 
        @items = IntegrationItem.all
      end

      def show
        @item = IntegrationItem.find_by_item_title(params[:id])

        if flash[:token].blank?
          unless !@item.nil?
            redirect_to manage_integrations_url
          end
          session[:item_name] = @item.item_title
        else
          @token = flash[:token]
        end
      end

      def authenticate
        callback = oauth_callback_manage_integrations_url
        token = $qb_oauth_consumer.get_request_token(:oauth_callback => callback)
        session[:qb_request_token] = Marshal.dump(token)
        redirect_to("http://appcenter.intuit.com/Connect/Begin?oauth_token=#{token.token}") and return
      end

      def oauth_callback
        at = Marshal.load(session[:qb_request_token]).get_access_token(:oauth_verifier => params[:oauth_verifier])
        token = at.token
        secret = at.secret
        realm_id = params['realmId']

        params[:id] = session[:item_name]
        IntegrationItem.register_token(params[:id], token, secret, realm_id)
        redirect_to(manage_integrations_url + '/' + params[:id], flash:{ token: token_params }, notice: "Your QuickBooks account has been successfully linked.") and return
      end

      def disconnect
        set_qb_service('AccessToken')
        result = @service.disconnect

        if result.error_code == '270'
          msg = 'Disconnect failed as OAuth token is invalid. Try connecting again.'
        else
          msg = 'Successfully disconnected from QuickBooks'
        end

        session[:token] = nil
        session[:secret] = nil
        session[:realm_id] = nil
        # removing oauth infos from db
        IntegrationItem.register_token(session[:item_name], nil, nil, nil)
        redirect_to manage_integrations_url + '/' + session[:item_name], notice: msg
      end

      def push_info
        set_session_token('Quickbooks')
        set_qb_service('Customer')
        customer = Quickbooks::Model::Vendor.new
        customer.given_name = Customer.first.name
        @service.create(customer)

        redirect_to manage_integrations_url + '/' + session[:item_name], notice: "Data have been pushed to Quickbooks successfully!"
      end

      def pull_info

      end

      protected
        def authorize_vendor
          if current_spree_user.nil?
          flash[:error] = "You must be logged in"
          redirect_to root_url
          elsif !current_spree_user.has_spree_role?('vendor')
          flash[:error] = "You do not have permission to view the page requested"
          redirect_to root_url
          end
        end

        def set_session_token(item_title)
          item = IntegrationItem.find_by_item_title(item_title)

          if !item.nil?
            session[:token] = item.app_token
            session[:secret] = item.consumer_secret
            session[:realm_id] = item.consumer_key
          end
        end

        def set_qb_service(type = 'Vendor')
          oauth_client = OAuth::AccessToken.new($qb_oauth_consumer, session[:token], session[:secret])
          @service = "Quickbooks::Service::#{type}".constantize.new
          @service.access_token = oauth_client
          @service.realm_id = session[:realm_id]
        end

        def token_params
          params.permit(:oauth_token, :oauth_verifier, :realmId, :dataSource, :id)
        end
    end
  end
end
