FactoryBot.define do
  
  factory :wholesale_user, :parent => :user do
    spree_roles { [Spree::Role.find_or_create_by(name: "wholesaler")] }
  end

end