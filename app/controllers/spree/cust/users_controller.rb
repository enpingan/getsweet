module Spree
  module Cust
    class UsersController < Spree::Cust::CustomerHomeController

      def new
        @user = current_customer.users.new
        render :new
      end

      def create
        @user = current_customer.users.new(user_params)

        if @user.save
          redirect_to account_url
        else
          flash[:errors] = @user.errors.full_messages
          render :new
        end
      end

      def edit
        @user = Spree::User.find(params[:id])
        render :edit
      end

      def update
        @user = Spree::User.find(params[:id])
        if @user.update(user_params)
          redirect_to account_url
        else
          flash[:errors] = @user.errors.full_messages
          render :edit
        end
      end

      def destroy
        @user = Spree::User.find(params[:id])
        @user.destroy!
        redirect_to account_url
      end

      private

      def user_params
        params.require(:user).permit(:firstname, :lastname, :email, :phone, :password, :user_type)
      end

    end
  end
end
