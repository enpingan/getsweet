module Spree
  module Manage

	class ProductsController < Spree::Manage::BaseController

  def index
    #@vendor = Vendor.find(params[:vendor_id])
    #@products = @vendor.products
    @vendor = Vendor.first
		@current_order = current_order

    @products = Spree::Product.all
    render :index
  end

  def new
    @product = Spree::Product.new
    
  end

  def create
  end

  def show
    @product = Spree::Product.find(params[:id])
  end

  def edit
    @product = Spree::Product.find(params[:id])
    render :edit
  end

  def update
    @product = Spree::Product.find(params[:id])

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

end


  # /. Vendor
  end
# /. Spree
end
