# frozen_string_literal: true

module SolidusEasypost
  class ShipmentStateHandler
    def self.call(payload)
      return unless payload['description'] == 'tracker.updated'

      shipment = find_shipment_by_tracker_id(payload['result']['id'])
      return unless shipment

      ::Spree::Bus.publish :'solidus_easypost.shipment_tracker.updated', shipment: shipment, payload: payload
    end

    def self.find_shipment_by_tracker_id(tracker_id)
      ::Spree::Shipment.find_by(easy_post_tracker_id: tracker_id) ||
      ::Spree::Shipment.find_by(easy_post_inbound_tracker_id: tracker_id)
    end
  end
end
