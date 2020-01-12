Spree::Core::Engine.add_routes do
  # Add your extension routes here
  namespace(:admin) do
    resources :users do
      resources :wholesalers, only: [:update, :create, :edit, :new]
    end

    resources :wholesalers, only: :index

    resource :wholesale_configurations, only: [:update, :edit]
  end

  namespace :api, defaults: { format: 'json' } do
    namespace :v2 do

      namespace :storefront do
        resources :wholesalers, only: [:show, :index]
      end
    end
  end

end
