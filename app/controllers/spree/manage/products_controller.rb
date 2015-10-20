module Spree
  module Manage

	class ProductsController < Spree::Manage::BaseController

    before_action :ensure_vendor, only: [:show, :edit, :update, :destroy]

  def index
    @vendor = current_vendor
    #@vendor = Vendor.find(params[:vendor_id])
    #@products = @vendor.products
    # @vendor = Vendor.first
    if @vendor.orders.present?
	    @current_order = @vendor.orders.last
    end
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

end


  # /. Vendor
  end
# /. Spree
end
