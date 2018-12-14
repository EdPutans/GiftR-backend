Rails.application.routes.draw do
  Rails.application.routes.draw do
    namespace :api do
      namespace :v1 do
        resources :users
        post 'signin', to: 'users#signin'
        get 'validate', to: 'users#validate'
        get 'get_items', to: 'users#get_items'
        resources :gifts
        # resources :follows
        # resources :friends
      end
    end
  end
end
