Spree::Core::Engine.add_routes do
  # Add your extension routes here
  namespace(:admin) do

    resources :wholesalers do
      member do
        get :approve
        get :reject
      end
    end

    get '/users/wholesalers', to: 'users#wholesalers'

    resource :wholesale_configurations

  end

  namespace :api, defaults: { format: 'json' } do
    namespace :v2 do

      namespace :storefront do
        resources :wholesalers, only: [:show, :index]
      end
    end
  end

end
