FactoryBot.define do
  factory :wholesaler, class: Spree::Wholesaler do
    user { create(:wholesale_user) }
    company { "Test Company" }
    buyer_contact { "Mr Contacter" }
    manager_contact { "Mr Manager" }
    phone { "555-555-5555" }
    web_address { "testcompany.com" }
    alternate_email { "alternate@testcompany.com" }
    notes { "Some sort of note" }
    bio { "This is my bio!" }
    business_address { create(:business_address) }
  end
end
