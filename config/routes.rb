Rails.application.routes.draw do
  root 'home#top'
  devise_for :users
  resources :users,only: [:show,:index,:edit,:update]
  resources :books
  get 'home/about'
end