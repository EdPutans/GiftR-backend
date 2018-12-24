Rails.application.routes.draw do
  Rails.application.routes.draw do
    namespace :api do
      namespace :v1 do
        resources :users

        get 'validate', to: 'users#validate'
        get 'get_items', to: 'users#get_items'
        get 'users/:id/friends', to: 'users#friends'
        get 'users/:id/unaccepted', to: 'users#unaccepted'

        post 'signin', to: 'users#signin'
        post 'users/search_user', to: 'users#find_user'
        post 'users/:id/add_friend', to: 'users#add_friend'
        post 'users/friend_request', to: 'users#friend_request'

        patch 'users/confirm_or_reject', to: 'users#confirm_or_reject'

        resources :gifts
      end
    end
  end
end
