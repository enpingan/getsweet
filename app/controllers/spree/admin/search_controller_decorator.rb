Spree::Admin::SearchController.class_eval do
  def customers
    if params[:ids]
      @customers = Spree::Customer.where(id: params[:ids].split(",").flatten)
    else
      @customers = Spree::Customer.ransack(params[:q]).result
    end

    @customers = @customers.distinct.page(params[:page]).per(params[:per_page])
    expires_in 15.minutes, public: true
    headers['Surrogate-Control'] = "max-age=#{15.minutes}"
  end
end
