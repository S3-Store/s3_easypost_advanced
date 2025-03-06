# frozen_string_literal: true

module Spree
  module OrderDecorator
    def self.prepended(base)
      base.state_machine.after_transition to: :complete, do: :generate_labels
    end

    def payment_required?
      # First, check the existing condition: if total is 0 or less, no payment is needed.
      return false unless total > 0

      # Collect all products from the order's line items.
      products = line_items.map { |li| li.variant.product }

      # Check if any product has a product_type value of 2 (trade-in).
      trade_in_present = products.any?(&:trade_in?)

      # Check if any product has a product_type value that is not 2.
      other_product_present = products.any? { |product| !product.trade_in? }

      # If both trade-in and non trade-in products are present, raise an error.
      if trade_in_present && other_product_present
        raise "Invalid order: cannot mix trade-in and non trade-in products."
      end

      # If only trade-in products are present, payment is not required.
      return false if trade_in_present

      # Otherwise, payment is required.
      true
    end

    private

    def generate_labels
      shipments.each(&:label_for_complete_order)
      shipments.each(&:generate_inbound_roundtrip_labels)
    end
  end
end

Spree::Order.prepend(Spree::OrderDecorator)
