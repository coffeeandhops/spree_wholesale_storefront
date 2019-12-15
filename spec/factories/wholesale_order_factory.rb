FactoryBot.define do
 
  factory :wholesale_order, :parent => :order do
    transient do
      line_items_quantity { 50 }
      wholesaler { create(:wholesaler) }
    end
    
    user { wholesaler.user }

    factory :wholesale_over_min do
      after(:create) do |order, evaluator|
        create(:line_item, order: order, price: evaluator.line_items_price, quantity: evaluator.line_items_quantity)
        order.line_items.reload # to ensure order.line_items is accessible after
        order.line_items.each do |item|
          item.variant.wholesale_price = 10.0
          item.save
        end
        order.update_with_updater!
      end
    end

  end

end