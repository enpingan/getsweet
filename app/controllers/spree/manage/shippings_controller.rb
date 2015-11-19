module Spree
	module Manage
    class ShippingsController < Spree::Manage::BaseController

      def index
        @orders = current_vendor.orders.where('delivery_date >= ? AND state = ?', Time.current.to_date, 'complete').order('delivery_date ASC')
        render :index
      end

      def edit
        @order = Spree::Order.friendly.find(params[:order_id])

        render :edit
      end

      def update
        @order = Spree::Order.friendly.find(params[:order_id])
        if @order.update(shipping_params)
          @order.line_items.each do |line_item|
            line_item.received_qty = line_item.shipped_qty
            line_item.shipped_total = line_item.shipped_qty * line_item.price
          end
          @order.save!

          flash[:success] = "Shipping quantities have been updated"
          redirect_to manage_shippings_url if params[:commit] == "confirm"
        else
          flash[:errors] = @order.errors.full_messages
          render :edit
        end


      end

      private

      def shipping_params
        params.require(:order).permit(
            line_items_attributes: [:id, :shipped_qty, :shipped_total]
          )
      end

    end
  end
end
