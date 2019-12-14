FactoryBot.define do
  factory :wholesale_line_item, parent: :line_item do
    variant { create(:wholesale_variant) }
  end
end
