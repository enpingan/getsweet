class Spree::Cust::UserImagesController < Spree::Cust::ResourceController
  before_action :load_edit_data, only: [:edit, :update]
  before_action :load_index_data, only: :index

  create.before :set_viewable
  update.before :set_viewable


  def new
    @user_image = Spree::UserImage.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_image }
    end
  end

  def create
    @user_image = spree_current_user.images.create(user_image_params)
    if @user_image.save
      flash[:success] = "Account image saved!"
      redirect_to account_user_user_images_url
    else
      flash[:errors] = @user_image.errors.full_messages
      render :new
    end 
  end 

  def edit
      @user_image = Spree::UserImage.find(params[:id])

        session[:id] = @user.id
        render :edit
      end 

      def update
        @user_image = Spree::UserImage.find(params[:id])
        session[:id] = @user_image.id
        if @user_image.update(user_image_params)
          flash[:success] = "Image updated!"
          redirect_to account_user_user_images_url(@user_image)
        else
          flash[:errors] = @user_image.errors.full_messages
          render :edit
        end 
      end 

	protected

		def user_image_params
          params.require(:user_image).permit(
						:attachment,
						:alt,
            :viewable_type,
            :viewable_id
					)  
		end

  private

    def location_after_destroy
      account_user_user_images_url
    end

    def location_after_save
      account_user_user_images_url
    end

    def load_index_data
      @user = spree_current_user
    end 

    def load_edit_data
      @user = spree_current_user
			@user_image = Spree::UserImage.find(params[:id])
    end

    def set_viewable
      @user_image.viewable_type = 'Spree::User'
      @user_id = spree_current_user
      @user_image.viewable_id = @user_id.id
    end
  
end
