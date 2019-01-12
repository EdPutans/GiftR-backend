

Rails.application.routes.draw do
  Rails.application.routes.draw do
    root to: 'users#index'
    namespace :api do
      namespace :v1 do
        resources :users
        resources :friendships
        resources :gifts
        resources :santas
        get 'validate', to: 'users#validate'
        get 'get_items', to: 'users#get_items'
        get 'users/:id/friends', to: 'users#friends'

        get 'friendships/:user_id/active_requests', to: 'friendships#active_requests'
        get 'friendships/:user_id/active_request_ids', to: 'friendships#active_request_ids'

        get 'friendships/:user_id/unaccepted', to: 'friendships#unaccepted'
        get 'friendships/:user_id/unaccepted_ids', to: 'friendships#unaccepted_ids'
        get 'users/:user_id/santas', to: 'santas#get_gifter_santas'

        post 'signin', to: 'users#signin'
        post 'users/search_user', to: 'users#find_user'
        post 'users/:id/add_friend', to: 'users#add_friend'
        post 'users/friend_request', to: 'users#friend_request'
        post 'santas/create_santa_list', to: 'santas#create_santa_list'

        patch 'santas/:id/mark_read', to: 'santas#mark_read'
        patch 'users/confirm_or_reject', to: 'users#confirm_or_reject'

      end
    end
  end
end
