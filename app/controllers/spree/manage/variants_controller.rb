module Spree
  module Manage

    class VariantsController < ApplicationController
      def index
        @variants = Spree::Product.find(params[:product_id]).variants_including_master
        render :index
      end

      def new
      end

      def create
        @variant = Spee::Variant.new(variant_params)
        @variant.product_id = Spree::Product.find(params[:product_id])

        if @variant.save
          redirect_to manage_product_url(@variant.product_id)
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
          redirect_to manage_product_url(@variant.product_id)
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
    end

  end
end
