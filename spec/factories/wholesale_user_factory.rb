FactoryBot.define do
  
  factory :wholesale_user, :parent => :user do
    spree_roles { [Spree::Role.find_or_create_by(name: "wholesaler")] }
  end


  factory :wholesale_user_with_addresses, :parent => :user_with_addresses do
    after(:create) do |user, evaluator|
      user.build_wholesaler(company: "ACME", buyer_contact: "Wile E Coyote", phone: "555-6677-88")
      user.save
      user.reload
    end

  end
end