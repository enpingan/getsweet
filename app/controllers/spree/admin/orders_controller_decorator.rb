Spree::Admin::OrdersController.class_eval do

  def delivery_update
    @order = Spree::Order.find_by(:number => params[:id])
    @order.update_attribute(:delivery_date, params[:order][:delivery_date])
    redirect_to :back
  end
  #
  private
  def order_params
    params[:created_by_id] = try_spree_current_user.try(:id)
    params.permit(:customer_id, :delivery_date,
      :user_id, :created_by_id)
  end

end
