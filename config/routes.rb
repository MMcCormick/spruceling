KidSwap::Application.routes.draw do
  resources :items

  # Boxes
  resources :boxes
  put 'boxes/add_item'

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users, :only => [:show, :index]
end
