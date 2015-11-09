class Spree::Admin::VendorImagesController < Spree::Admin::ResourceController
  #before_action :load_data
  before_action :load_edit_data, except: :index
  before_action :load_index_data, only: :index

  create.before :set_viewable
  update.before :set_viewable

  private

    def location_after_destroy
      admin_vendor_vendor_images_url(@vendor)
    end

    def location_after_save
      admin_vendor_vendor_images_url(@vendor)
    end

    def load_index_data
      @vendor = Spree::Vendor.friendly.find(params[:vendor_id])
    end 

    def load_edit_data
      @vendor = Spree::Vendor.friendly.find(params[:vendor_id])
    end

    #def load_data
    #  @vendor = Spree::Vendor.friendly.find(params[:vendor_id])
    #end

    def set_viewable
      @vendor_image.viewable_type = 'Spree::Vendor'
      @vendor_id = Spree::Vendor.friendly.find(params[:vendor_id])
      @vendor_image.viewable_id = @vendor_id.id
    end
  
end
