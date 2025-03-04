# frozen_string_literal: true

module SolidusEasypost
  module Calculator
    class WeightDimensionCalculator < BaseDimensionCalculator
      protected

      def compute_for_return_authorization(return_authorization)
        total_weight = return_authorization.inventory_units.joins(:variant).sum(:weight)
        SolidusEasypost::ParcelDimension.new(weight: total_weight)
      end

      def compute_for_package(package)
        total_weight = 0.0
        total_height = 0.0
        max_width = 0.0
        max_depth = 0.0

        package.contents.each do |item|
          variant = item.variant
          total_weight += variant.weight * item.quantity
          total_height += variant.height * item.quantity
          max_width = [max_width, variant.width].max
          max_depth = [max_depth, variant.depth].max
        end

        SolidusEasypost::ParcelDimension.new(
          weight: total_weight,
          height: total_height,
          width: max_width,
          depth: max_depth
        )
      end
    end
  end
end
