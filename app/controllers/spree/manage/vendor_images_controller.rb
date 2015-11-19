class Spree::Manage::VendorImagesController < Spree::Manage::ResourceController
  before_action :load_edit_data, only: [:edit, :update]
  before_action :load_index_data, only: :index

  create.before :set_viewable
  update.before :set_viewable


  def new
    @account_image = Spree::VendorImage.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @account_image }
    end
  end

  def create
    @account_image = spree_current_user.vendor.images.create(vendor_image_params)
    if @account_image.save
      flash[:success] = "Account image saved"
      redirect_to manage_account_account_images_url
    else
      flash[:errors] = @account_image.errors.full_messages
      render :new
    end 
  end 

  def edit
      @account_image = Spree::VendorImage.find(params[:id])

        session[:id] = @account.id
        render :edit
      end 

      def update
        @account_image = Spree::VendorImage.find(params[:id])
        session[:id] = @account_image.id
        if @account_image.update(vendor_image_params)
          flash[:success] = "Account image updated"
          redirect_to manage_account_account_images_url(@account_image)
        else
          flash[:errors] = @account_image.errors.full_messages
          render :edit
        end 
      end 

	protected

		def vendor_image_params
          params.require(:vendor_image).permit(
						:attachment,
						:alt,
            :viewable_type,
            :viewable_id
					)  
		end

  private

    def location_after_destroy
      manage_account_account_images_url
    end

    def location_after_save
      manage_account_account_images_url
    end

    def load_index_data
      @account = spree_current_user.vendor
    end 

    def load_edit_data
      @account = spree_current_user.vendor
			@account_image = Spree::VendorImage.find(params[:id])
    end

    def set_viewable
      @account_image.viewable_type = 'Spree::Vendor'
      @account_id = spree_current_user.vendor
      @account_image.viewable_id = @account_id.id
    end
  
end
