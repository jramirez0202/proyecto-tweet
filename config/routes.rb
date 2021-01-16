Rails.application.routes.draw do
  root to: "tweets#index"

  #probando autenticacion de usuario con devise
  devise_for :users, skip: %i[registrations sessions passwords]
  devise_scope :user do
    post '/signup', to: 'registrations#create'
    post '/login', to: 'sessions#create'
    delete '/logout', to: 'sessions#destroy'
  end
  post 'api/news/:email', to: "api#create_tweets_api"

  scope '/api' do
    get '/dates_ranges/:startDate/:endDate', to: 'api#dates_ranges', as: 'dates_ranges'
  end

  get 'api/news'

  # post 'api/tweet', to: 'tweets#apiCreate'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  #rutas para el follow unfollow
  resources :tweets do
    member do
      post 'follow/:id', to: 'tweets#follow', as: 'follow'
    end
  end
  delete 'follow/:id', to: 'tweets#destroy_following', as: 'destroy_following'

  #ruta del modelo tag
  get '/tweets/hashtag/:name', to:'tweets#hashtags'




  #route para likes y retweet
  post 'likes/:tweet_id', to: 'likes#create', as: 'likes'
  post 'tweets/:id', to: 'tweets#retweet'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
