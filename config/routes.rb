Rails.application.routes.draw do
  Rails.application.routes.draw do
    namespace :api do
      namespace :v1 do
        resources :users
        resources :gifts
        # resources :follows
        # resources :friends
      end
    end
  end
end
