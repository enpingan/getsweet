module Spree
  module Manage

	class ProductsController < Spree::Manage::BaseController
    helper_method :sort_column, :sort_direction
    before_action :ensure_vendor, only: [:show, :edit, :update, :destroy]
    before_action :clear_current_order, only: [:new, :create]

  def index
    @vendor = current_vendor
    @current_customer = current_customer
    @current_order = current_order

    if params[:sort] && params[:sort] == 'price'
      @products = sort_direction == 'asc' ? @vendor.products.ascend_by_master_price : @vendor.products.descend_by_master_price
    else
      @products = @vendor.products.order(sort_column + ' ' + sort_direction)
    end

    render :index
  end

  def new
    @vendor = current_vendor
    @product = current_vendor.products.new

    render :new
  end

  def create
    @vendor = current_vendor
    @product = current_vendor.products.new(product_params)
    @product.shipping_category_id ||= 1 #default value required to create new product
    if @product.save
      flash[:success] = "New product added!"
      redirect_to manage_products_url
    else
      flash[:errors] = @product.errors.full_messages
      render :new
    end
  end

  def show
    @vendor = current_vendor
    @current_customer = current_customer
    @current_order = current_order
    @product = Spree::Product.friendly.find(params[:id])
    @variants_including_master = [@product.master] + @product.variants

    render :show
  end

  def edit
    @product = Spree::Product.friendly.find(params[:id])
    @variants = @product.variants
    @vendor = current_vendor
    # Temporary allergans
    @allergans = ['Peanut', 'Tree Nuts', 'Milk', 'Egg', 'Wheat', 'Soy', 'Fish', 'Shellfish']

    render :edit
  end

  def update
    @product = Spree::Product.friendly.find(params[:id])
    @vendor = current_vendor
    if params[:commit] == 'Add Variant'
      @variant = @product.variants.build
      render :edit and return
    end

    if @product.update(product_params)
      flash[:success] = "Product has been updated!"
      redirect_to manage_product_url(@product)
    else
      flash[:errors] = @product.errors.full_messages
      render :edit
    end
  end

  def destroy_variant
    @variant = Spree::Variant.find(params[:variant_id])
    unless @variant.is_master
      @variant.destroy!
    else
      flash.now[:error] = "You cannot delete the master variant."
      render :edit
    end
    redirect_to edit_manage_product_url(params[:product_id])
  end

  protected

  def product_params
    params.require(:product).permit(:name, :description, master_attributes: [:sku, :price, :pack_size, :lead_time, :id, :is_master, prices_attributes: [:id, :amount]],
      variants_attributes: [:sku, :price, :lead_time, :pack_size, :id, :is_master, prices_attributes: [:id, :amount]])
  end

  def ensure_vendor
    @product = Spree::Product.friendly.find(params[:id])
    unless current_vendor.id == @product.vendor_id
      flash[:error] = "You don't have permission to view the requested page"
      redirect_to root_url
    end
  end

  # def current_order
  #   if session[:order_id]
  #     @current_order = Spree::Order.find(session[:order_id])
  #     return nil unless current_customer && @current_order.customer.id == current_customer.id
  #   end
  #   @current_order
  # end

  def current_customer
    if session[:customer_id]
      @current_customer = Spree::Customer.find(session[:customer_id])
    end
      @current_customer
  end

  def sort_column
    (Spree::Product.column_names.include?(params[:sort]) || params[:sort] == 'price') ? params[:sort] : "name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
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
