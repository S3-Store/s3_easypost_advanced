# frozen_string_literal: true

module Spree
  module OrderDecorator
    def self.prepended(base)
      base.state_machine.before_transition to: :complete, do: :set_order_type
      base.state_machine.after_transition to: :complete, do: :generate_labels
    end

    def payment_required?
      # First, check the existing condition: if total is 0 or less, no payment is needed.
      return false unless total > 0

      # Check if any product has a product_type value that is not 2.
      other_product_present = products.any? { |product| !product.trade_in? }

      # If both trade-in and non trade-in products are present, raise an error.
      if trade_in_order? && other_product_present
        raise "Invalid order: cannot mix trade-in and non trade-in products."
      end

      # If only trade-in products are present, payment is not required.
      return false if trade_in_order?

      # Otherwise, payment is required.
      true
    end

    private

    def generate_labels
      shipments.each(&:label_for_complete_order)
      shipments.each(&:generate_inbound_roundtrip_labels)
    end

    def set_order_type
      return unless trade_in_order?

      customer_metadata["order_type"] = 'Trade-In'
    end

    def trade_in_order?
      # Collect all products from the order's line items and check if any product is a trade-in.
      line_items.any? { |li| li.variant.product.trade_in? }
    end
  end
end

Spree::Order.prepend(Spree::OrderDecorator)
