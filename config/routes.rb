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

end
