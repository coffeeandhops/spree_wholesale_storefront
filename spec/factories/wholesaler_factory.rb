FactoryBot.define do
  factory :wholesaler, class: Spree::Wholesaler do
    user { create(:user) }
    bill_address { create(:bill_address) }
    ship_address { create(:ship_address) }
    company { "Test Company" }
    buyer_contact { "Mr Contacter" }
    manager_contact { "Mr Manager" }
    phone { "555-555-5555" }
    web_address { "testcompany.com" }
    alternate_email { "alternate@testcompany.com" }
    notes { "Some sort of note" }
  end
end
