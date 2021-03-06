module Spree
  module Manage
    class ImagesController < ResourceController
      before_action :load_data

      create.before :set_viewable
      update.before :set_viewable

			def index
			end

      private

        def location_after_destroy
          manage_product_images_url(@product)
        end

        def location_after_save
          manage_product_images_url(@product)
        end

        def load_data
          @product = Product.friendly.find(params[:product_id])
          @variants = @product.variants.collect do |variant|
            [variant.sku_and_options_text, variant.id]
          end
          @variants.insert(0, [Spree.t(:all), @product.master.id])
        end

        def set_viewable
          @image.viewable_type = 'Spree::Variant'
          @image.viewable_id = params[:image][:viewable_id]
        end

    end
  end
end
