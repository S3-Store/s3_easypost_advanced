# frozen_string_literal: true

module CartLineItemsControllerDecorator
  def create
    @order = current_order(create_order_if_necessary: true)
    authorize! :update, @order, cookies.signed[:guest_token]

    variant  = Spree::Variant.find(params[:variant_id])
    quantity = params[:quantity].present? ? params[:quantity].to_i : 1

    customer_metadata = params.require(:customer_metadata).permit! if params[:customer_metadata].present?
    # 2,147,483,647 is crazy. See issue https://github.com/spree/spree/issues/2695.
    if quantity.between?(1, 2_147_483_647)
      begin
        @line_item = @order.contents.add(variant, quantity)
        if customer_metadata.present?
          customer_metadata.each do |key, value|
            next unless key == "line_item_identifier"

            @line_item.customer_metadata[key] ||= []
            @line_item.customer_metadata[key] << value
          end
          @line_item.save
        end
      rescue ActiveRecord::RecordInvalid => e
        @order.errors.add(:base, e.record.errors.full_messages.join(", "))
      end
    else
      @order.errors.add(:base, t('spree.please_enter_reasonable_quantity'))
    end

    respond_to do |format|
      format.html do
        if @order.errors.any?
          flash[:error] = @order.errors.full_messages.join(", ")
          redirect_back_or_default(root_path)
          return
        else
          redirect_to cart_path
        end
      end
    end
  end
end

CartLineItemsController.prepend(CartLineItemsControllerDecorator)
