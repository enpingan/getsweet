module Spree
	module Manage
    class ShippingsController < Spree::Manage::BaseController

      def index
				@shipments = current_vendor.shipments
				# @orders = current_vendor.orders.('shipment IS NOT NULL')
        # @orders = current_vendor.orders.where('delivery_date >= ? AND state = ?', Time.current.to_date, 'complete').order('delivery_date ASC')
        render :index
      end

      def edit
        # @order = Spree::Order.friendly.find(params[:order_id])
				@shipment = Spree::Shipment.friendly.find(params[:id])
				@order = @shipment.order

        render :edit
      end

      def update
        # @order = Spree::Order.friendly.find(params[:order_id])
				@shipment = Spree::Shipment.friendly.find(params[:id])
				@order = @shipment.order
				if params[:commit] = 'confirm'
					@shipment.state = 'ready' if @shipment.state == "pending"
					if @shipment.state == "ready"
						@shipment.ship
					end
				end

        if @order.update(shipping_params)
          @order.line_items.each do |line_item|
            # line_item.received_qty = line_item.shipped_qty
            line_item.shipped_total = line_item.shipped_qty * line_item.price
          end
          @order.save!

          # flash[:success] = "Shipping quantities have been updated"
          redirect_to manage_shippings_url if params[:commit] == "confirm"
        else
          flash[:errors] = @order.errors.full_messages
          render :edit
        end


      end

      private

      def shipping_params
        params.require(:order).permit(
            line_items_attributes: [:id, :shipped_qty, :shipped_total],
						notes_attributes: [:body, :id]
          )
      end

    end
  end
end
