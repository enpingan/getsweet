module Spree
  module Manage

    class VariantsController < Spree::Manage::BaseController
      before_action :ensure_vendor

      def index
        @variants = Spree::Product.friendly.find(params[:product_id]).variants_including_master
        render :index
      end

      def new
        @variant = Spree::Variant.new
        @product = Spree::Product.friendly.find(params[:product_id])
      end

      def create
        @variant = Spee::Variant.new(variant_params)
        @product = Spree::Product.friendly.find(params[:product_id])
        @variant.product_id = @product.id

        if @variant.save
          redirect_to manage_product_url(@variant.product)
        else
          render :new
        end
      end

      def show
        @variant = Spree::Variant.find(params[:id])
        render :show
      end

      def edit
        @variant = Spree::Variant.find(params[:id])
        @product = @variant.product
        render :edit
      end

      def update
        @variant = Spree::Variant.find(params[:id])
        @product = @variant.product

        if @variant.update(variant_params)
          redirect_to manage_product_url(@variant.product)
        else
          render :edit
        end
      end

      def destroy
      end

      protected

      def variant_params
        params.require(:variants).permit(:sku, :price)
      end

      def ensure_vendor
        @product = Spree::Product.friendly.find(params[:product_id])
        redirect_to login_url unless current_vendor.id == @product.vendor_id
      end
    end

  end
end
