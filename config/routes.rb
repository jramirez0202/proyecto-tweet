Rails.application.routes.draw do


  # post 'likes/:tweet_id', to: 'likes#create', as: 'likes'
  # resources :tweets do
  #   resources :likes
  # end

  resources :tweets

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root to: "tweets#index"
  post 'likes/:tweet_id', to: 'likes#create', as: 'likes'
  post 'tweets/:id', to: 'tweets#retweet'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
