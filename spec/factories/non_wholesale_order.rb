FactoryBot.define do
 
  factory :non_wholesale_order, :parent => :order do
    transient do
      line_items_quantity { 1 }
      line_items_price { 20.0 }
    end

    factory :non_wholesale_order_with_line_items do
      bill_address
      ship_address

      transient do
        line_items_count       { 1 }
        without_line_items     { false }
        shipment_cost          { 100 }
        shipping_method_filter { Spree::ShippingMethod::DISPLAY_ON_FRONT_END }
        line_item_qty          { 1 }
      end

      after(:create) do |order, evaluator|
        unless evaluator.without_line_items
          create_list(:wholesale_line_item, evaluator.line_items_count, order: order, price: evaluator.line_items_price, wholesale_price: 0.0, quantity: evaluator.line_item_qty)
          order.line_items.reload
        end

        create(:shipment, order: order, cost: evaluator.shipment_cost)
        order.shipments.reload

        order.update_with_updater!
      end
    end
  end
end