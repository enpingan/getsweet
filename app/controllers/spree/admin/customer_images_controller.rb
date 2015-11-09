class Spree::Admin::CustomerImagesController < Spree::Admin::ResourceController
  #before_action :load_data
  before_action :load_edit_data, except: :index
  before_action :load_index_data, only: :index

  create.before :set_viewable
  update.before :set_viewable

  private

    def location_after_destroy
      admin_customer_customer_images_url(@customer)
    end

    def location_after_save
      admin_customer_customer_images_url(@customer)
    end

    def load_index_data
      @customer = Spree::Customer.find(params[:customer_id])
    end 

    def load_edit_data
      @customer = Spree::Customer.find(params[:customer_id])
    end

    #def load_data
    #  @vendor = Spree::Vendor.friendly.find(params[:vendor_id])
    #end

    def set_viewable
      @customer_image.viewable_type = 'Spree::Customer'
      @customer_id = Spree::Customer.find(params[:customer_id])
      @customer_image.viewable_id = @customer_id.id
    end
  
end
