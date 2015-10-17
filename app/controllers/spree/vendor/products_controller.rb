module Spree
  module Vendor
	
	
	class ProductsController < ApplicationController
  def index
    @vendor = Vendor.find(params[:vendor_id])
    @products = @vendor.products
    render :index
  end

  def show
    @product = Spree::Product.find(params[:id])
    render :show
  end

  def edit
    @product = Spree::Product.find(params[:id])
    render :edit
  end

  def update
    @product = Spree::Product.find(params[:id])
    if @product.update(product_params)
      redirect_to vendor_product_url(@product.vendor_id, @product.id)
    else
      render :edit
    end
  end

private

def product_params #need to add all permitable attributes, just name and price for now
  params.require(:product).permit(:name, :price)
end

end


  # /. Vendor
  end 
# /. Spree
end
