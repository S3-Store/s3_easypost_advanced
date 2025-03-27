# frozen_string_literal: true

module SolidusEasypost
  class StatusTracker
    include Omnes::Subscriber

    handle :'solidus_easypost.shipment_tracker.updated',
      with: :handle_shipment_tracker_updated

    def handle_shipment_tracker_updated(event)
      shipment = event.payload[:shipment]
      payload = event.payload[:payload]
      tracker_id = payload[:result][:id]
      status = payload[:result][:status]

      if shipment.easy_post_tracker_id == tracker_id
        update_outbound_shipment_status(shipment, status)
      elsif shipment.easy_post_inbound_tracker_id == tracker_id
        update_inbound_shipment_status(shipment, status)
      end
    rescue StandardError => e
      Rails.logger.error("Failed to update shipment status: #{e.message}")
    end

    private

    def update_outbound_shipment_status(shipment, status)
      case status
      when 'in_transit'
        shipment.ship!
      end
    end

    def update_inbound_shipment_status(shipment, status)
      case status
      when 'pre_transit', 'unknown'
        shipment.inbound_ready! unless shipment.inbound_ready?
      when 'in_transit', 'out_for_delivery'
        shipment.inbound_ship! unless shipment.inbound_shipped?
      when 'delivered'
        shipment.pending! unless shipment.pending?
      end
    end
  end
end
