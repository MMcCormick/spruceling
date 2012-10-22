Spruceling::Application.routes.draw do

  resources :orders

  resources :items

  # Boxes
  resources :boxes
  scope :boxes do
    put 'add_item' => 'boxes#add_item'
    put 'remove_item' => 'boxes#remove_item'
  end

  scope 'users' do
    post 'update_stripe' => 'users#update_stripe', :as => :user_update_stripe
    put 'update_address' => 'users#update_address', :as => :update_user_address
    get 'edit_information' => 'users#edit_information', :as => :edit_user_information
    get ':id' => 'users#show', :as => :user
    get ':id/page/:page' => 'users#show'
  end

  scope 'cart' do
    get '' => 'carts#show', :as => :cart
    put 'add' => 'carts#add', :as => :cart_add
    put 'remove' => 'carts#remove', :as => :cart_remove
  end

  authenticated :user do
    root :to => 'home#index'
  end

  mount Attachinary::Engine => "/attachinary"

  root :to => "home#index"
  get 'page/:page' => 'home#index'

  devise_for :users
  resources :users, :only => [:show, :index]

end
