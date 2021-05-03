FactoryBot.define do
  factory :wholesale_line_item, parent: :line_item do
    # order { create(:wholesale_over_min) }
    quantity { 50 }
    variant { create(:wholesale_variant) }
    wholesale_price { variant.wholesale_price }
  end
end