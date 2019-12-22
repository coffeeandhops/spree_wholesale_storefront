FactoryBot.define do
  factory :wholesale_price, class: Spree::WholesalePrice do
    variant
    amount   { 15.00 }
    currency { 'USD' }
  end
end
