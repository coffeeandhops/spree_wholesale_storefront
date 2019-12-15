FactoryBot.define do
  factory :wholesale_line_item, parent: :line_item do
    # order { create(:wholesale_over_min) }
    variant { create(:wholesale_variant) }
  end
end
