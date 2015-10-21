Spree::Admin::OrdersController.class_eval do

  private
  def order_params
    params[:created_by_id] = try_spree_current_user.try(:id)
    params.permit(:created_by_id, :user_id)
  end

end
