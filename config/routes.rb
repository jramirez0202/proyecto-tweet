Rails.application.routes.draw do


  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

#rutas para el follow unfollow
  resources :tweets do
    member do
      post 'follow/:id', to: 'tweets#follow', as: 'follow'
    end
  end
  
  delete 'follow/:id', to: 'tweets#destroy_following', as: 'destroy_following'

  # get 'friendships/create'
  # get 'friendships/destroy'




  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root to: "tweets#index"
  post 'likes/:tweet_id', to: 'likes#create', as: 'likes'
  post 'tweets/:id', to: 'tweets#retweet'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
