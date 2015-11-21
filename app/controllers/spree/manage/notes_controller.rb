module Spree
	module Manage
    class NotesController < Spree::Manage::BaseController

      def create
        if params[:order_id]
          @note = Spree::Order.friendly.find(params[:order_id]).notes.new(note_params)
        else
          @note = Spree::Order.friendly.find(params[:id]).notes.new(note_params)
        end

          @note.user_id = current_spree_user.id

          redirect_to session.delete(:return_to)
      end

      private

      def note_params
        params.require(:note).permit(:body)
      end

    end
  end
end
