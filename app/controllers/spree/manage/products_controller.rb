module Spree
  module Manage

	class ProductsController < Spree::Manage::BaseController

    before_action :ensure_vendor, only: [:show, :edit, :update, :destroy]

  def index
    @vendor = current_vendor
    #@vendor = Vendor.find(params[:vendor_id])
    #@products = @vendor.products
    # @vendor = Vendor.first
    @current_customer = current_customer

    @current_order = current_order

    # @products = Spree::Product.all
    @products = @vendor.products
    render :index
  end

  def new
    @vendor = current_vendor
    @product = @vendor.products.new
  end

  def create
  end

  def show
    @product = Spree::Product.friendly.find(params[:id])
    render :show

  end

  def edit
    @product = Spree::Product.friendly.find(params[:id])
    render :edit
  end

  def update
    @product = Spree::Product.friendly.find(params[:id])

    if @product.update(product_params)
      redirect_to manage_product_url
    else
      render :edit
    end
  end

  protected

  def product_params  #Add more permissions
    params.require(:product).permit(:name)
  end

  def ensure_vendor
    @product = Spree::Product.friendly.find(params[:id])
    redirect_to root_url unless current_vendor.id == @product.vendor_id
  end

  def current_order
    if session[:order_id]
      @current_order = Spree::Order.find(session[:order_id])
      return nil unless @current_order.customer.id == current_customer.id
    end
    @current_order
  end

  def current_customer
    if session[:customer_id]
      @current_customer = Spree::Customer.find(session[:customer_id])
    end
      @current_customer
  end

    # if session[:order_id]
    #   current_order = Spree::Order.find(session[:order_id])
    #   unless current_order.customer_id == current_customer_id
    #     current_order = current_vendor.orders.where('customer_id = ? AND delivery_date = ?' , current_customer_id, DateTime.tomorrow).limit(1).first
    #     if !current_order
    #       current_order = current_vendor.orders.create(customer_id: current_customer_id, delivery_date: DateTime.tomorrow)
    #     end
    #   end
    # else
    #   current_order = current_vendor.orders.where('customer_id = ? AND delivery_date = ?' , current_customer_id, DateTime.tomorrow).limit(1).first
    #   if !current_order
    #     current_order = current_vendor.orders.create(customer_id: current_customer_id, delivery_date: DateTime.tomorrow)
    #   end
    # end
    # session[:order_id] = current_order.id
    # current_order
  # end

end
  # /. Vendor
  end
# /. Spree
end
