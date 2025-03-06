# frozen_string_literal: true

module SolidusEasypost
  module Spree
    module ShipmentDecorator
      def self.prepended(base)
        # Previous flow was to create postage labels once the shipment is shipped
        # Now we are moving it to order complete is it expected?

        # base.state_machine.before_transition(
        #   to: :shipped,
        #   do: :buy_easypost_rate,
        #   if: -> { SolidusEasypost.configuration.purchase_labels }
        # )

        # base.state_machine.after_transition(
        #   to: :shipped,
        #   do: :generate_inbound_roundtrip_labels,
        #   if: -> { SolidusEasypost.configuration.purchase_labels }
        # )

        base.delegate(
          :easy_post_rate_id,
          :easy_post_shipment_id,
          to: :selected_shipping_rate,
          prefix: :selected,
          allow_nil: true,
        )
      end

      def easypost_shipment
        return unless selected_easy_post_shipment_id

        @easypost_shipment ||= SolidusEasypost.client.shipment.retrieve(selected_easy_post_shipment_id)
      end

      def easypost_postage_label_url
        easypost_shipment&.postage_label&.label_url
      end

      def generate_inbound_roundtrip_labels
        generate_inbound_label
        generate_return_label
      end

      def label_for_complete_order
        buy_easypost_rate
      end

      private

      def buy_easypost_rate
        # Skip label purchase if tracking information already exists.
        return if tracking

        easypost_shipment_id = easypost_shipment.id

        rate = easypost_shipment.rates.find do |easypost_rate|
          easypost_rate.id == selected_easy_post_rate_id
        end

        # Purchase the shipping label using the updated API syntax.
        easypost_shipment = SolidusEasypost.client.shipment.buy(
          easypost_shipment_id,
          rate: { id: rate.id }
        )

        self.tracking = easypost_shipment.tracking_code
      end

      def generate_inbound_label
        return if order.customer_metadata[:inbound_label_url].present?

        from_address = SolidusEasypost::AddressBuilder.from_address(order.ship_address)
        to_address = SolidusEasypost::AddressBuilder.from_stock_location(service_stock_location)

        options = {
          from_address_options: from_address,
          to_address_options: to_address
        }

        inbound_shipment = SolidusEasypost::ShipmentBuilder.from_package(to_package, options)
        rate = inbound_shipment.lowest_rate
        purchased_shipment = SolidusEasypost.client.shipment.buy(inbound_shipment.id, rate: { id: rate.id })

        # Create pickup using extracted methods
        pickup_details = create_easypost_pickup(purchased_shipment, from_address) if customer_metadata['pickup_day'].present?

        order.update!(
          customer_metadata: (order.customer_metadata || {}).merge(
            inbound_label_url: purchased_shipment.postage_label.label_url
          ).tap do |metadata|
            if pickup_details.present?
              metadata.merge!(
                pickup_id: pickup_details[:pickup].id,
                pickup_status: pickup_details[:pickup].status,
                pickup_min_datetime: pickup_details[:min_datetime],
                pickup_max_datetime: pickup_details[:max_datetime]
              )
            end
          end
        )
      rescue StandardError => e
        Rails.logger.error "Failed to generate inbound label or create pickup: #{e.message}"
        raise e
      end

      def generate_return_label
        return if order.admin_metadata[:return_label_url].present?

        from_address = SolidusEasypost::AddressBuilder.from_stock_location(service_stock_location)
        to_address = SolidusEasypost::AddressBuilder.from_address(order.ship_address)

        options = {
          from_address_options: from_address,
          to_address_options: to_address
        }

        return_shipment = SolidusEasypost::ShipmentBuilder.from_package(to_package, options)
        rate = return_shipment.lowest_rate
        return_label = SolidusEasypost.client.shipment.buy(return_shipment.id, rate: { id: rate.id })

        order.update!(admin_metadata: order.admin_metadata.merge(
          return_label_url: return_label.postage_label.label_url
        ))
      rescue StandardError => e
        Rails.logger.error "Failed to generate return label: #{e.message}"
      end

      # Need to decide a way to find the stock location
      def service_stock_location
        @service_stock_location ||= order.variants.first.product&.service_stock_location || order.variants.first.stock_locations.first
      end

      def create_easypost_pickup(purchased_shipment, from_address)
        # Parse pickup details
        pickup_day = Date.parse(customer_metadata['pickup_day'])
        start_time_str, end_time_str = customer_metadata['pickup_time'].split('-')

        # Create datetime objects
        min_datetime, max_datetime = build_pickup_datetimes(pickup_day, start_time_str, end_time_str)

        # Create and return pickup details
        {
          pickup: SolidusEasypost.client.pickup.create(
            address: from_address,
            shipment: purchased_shipment.id,
            min_datetime: min_datetime.iso8601,
            max_datetime: max_datetime.iso8601,
            instructions: "Please contact customer for pickup details."
          ),
          min_datetime: min_datetime,
          max_datetime: max_datetime
        }
      end

      def build_pickup_datetimes(pickup_day, start_time_str, end_time_str)
        min_time = Time.zone.parse(start_time_str)
        max_time = Time.zone.parse(end_time_str)

        [
          pickup_day.to_time.change(hour: min_time.hour, min: min_time.min),
          pickup_day.to_time.change(hour: max_time.hour, min: max_time.min)
        ]
      end

      ::Spree::Shipment.prepend self
    end
  end
end
