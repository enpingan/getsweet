Spree::Shipment.class_eval do

  belongs_to :receiver, class_name: "Spree::User", foreign_key: :receiver_id, primary_key: :id

  scope :received, -> { with_state('received') }

  state_machine initial: :pending, use_transactions: false do
      event :ready do
        transition from: :pending, to: :ready, if: lambda { |shipment|
          # Fix for #2040
          shipment.determine_state(shipment.order) == 'ready'
        }
      end

    event :pend do
      transition from: :ready, to: :pending
    end

    event :ship do
        transition from: [:ready, :canceled], to: :shipped
      end
      # after_transition to: :shipped, do: :after_ship

    event :receive do
      transition from: :shipped, to: :received
    end
    after_transition to: :received, do: :after_receive

    event :cancel do
      transition to: :canceled, from: [:pending, :ready]
    end
    after_transition to: :canceled, do: :after_cancel

    event :resume do
      transition from: :canceled, to: :ready, if: lambda { |shipment|
        shipment.determine_state(shipment.order) == 'ready'
      }
      transition from: :canceled, to: :pending, if: lambda { |shipment|
        shipment.determine_state(shipment.order) == 'ready'
      }
      transition from: :canceled, to: :pending
    end
    after_transition from: :canceled, to: [:pending, :ready], do: :after_resume
    end

    def after_receive
      order.update!
    end


    # Determines the appropriate +state+ according to the following logic:
    #
    # pending    unless order is complete and +order.payment_state+ is +paid+
    # shipped    if already shipped (ie. does not change the state)
    # received   order has been marked as received by the customer
    # ready      all other cases
    def determine_state(order)
      return 'canceled' if order.canceled?
      return 'pending' unless order.can_ship?
      return 'pending' if inventory_units.any? &:backordered?
      return 'shipped' if state == 'shipped'
      return 'received' if state == 'received'
      order.paid? ? 'ready' : 'pending'
    end
  end
