Rails.application.routes.draw do

  put '/tweet/:id/like', to: 'tweets#like', as: 'like'


  resources :tweets
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root to: "tweets#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
