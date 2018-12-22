Rails.application.routes.draw do
  Rails.application.routes.draw do
    namespace :api do
      namespace :v1 do
        resources :users
        post 'signin', to: 'users#signin'
        get 'validate', to: 'users#validate'
        get 'get_items', to: 'users#get_items'
        post 'users/search_user', to: 'users#find_user'

        get 'users/:id/friends', to: 'users#friends'
        post 'users/:id/add_friend', to: 'users#add_friend'

        patch 'users/:id/confirm_or_reject', to: 'users#confirm_or_reject'

        resources :gifts
      end
    end
  end
end
