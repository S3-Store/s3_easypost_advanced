# frozen_string_literal: true

module CheckoutsControllerDecorator
  def update_params
    case params[:state].to_sym
    when :address
      massaged_params.require(:order).permit(
        permitted_checkout_address_attributes
      )
    when :delivery
      massaged_params.require(:order).permit(
        permitted_checkout_delivery_attributes + [customer_metadata: {}]
      )
    when :payment
      if @order.covered_by_store_credit?
        massaged_params.fetch(:order, {})
      else
        massaged_params.require(:order)
      end.permit(
        permitted_checkout_payment_attributes
      )
    else
      massaged_params.fetch(:order, {}).permit(
        permitted_checkout_confirm_attributes
      )
    end
  end
end

CheckoutsController.prepend(CheckoutsControllerDecorator)
