KidSwap::Application.routes.draw do
  resources :items
  resources :boxes

  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users, :only => [:show, :index]
end
