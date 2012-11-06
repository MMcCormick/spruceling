Spruceling::Application.routes.draw do

  resources :brands

  get '/testing' => 'testing#test'

  resources :orders

  resources :items

  # Boxes
  resources :boxes
  scope :boxes do
    put 'add_item' => 'boxes#add_item'
    put 'remove_item' => 'boxes#remove_item'
  end

  # Users
  get '/users/auth/:provider' => 'omniauth_callbacks#passthru'
  devise_for :users, :controllers => { :omniauth_callbacks => "omniauth_callbacks" }
  scope 'users' do
    post 'update_stripe' => 'users#update_stripe', :as => :user_update_stripe
    put 'update_address' => 'users#update_address', :as => :update_user_address
    get 'address' => 'users#edit_address', :as => :edit_user_address
    get 'payment' => 'users#edit_payment', :as => :edit_user_payment
    get ':id/page/:page' => 'users#show'
  end
  resources :users, :only => [:show, :index, :edit]

  scope 'cart' do
    get '' => 'carts#show', :as => :cart
    put 'add' => 'carts#add', :as => :cart_add
    put 'remove' => 'carts#remove', :as => :cart_remove
  end

  authenticated :user do
    root :to => 'home#index'
  end

  mount Attachinary::Engine => "uploads"
  mount Soulmate::Server, :at => "sm"

  admin_constraint = lambda do |request|
    #request.env['warden'].authenticate? and request.env['warden'].user.role?('admin')
    true
  end
  constraints admin_constraint do
    mount Sidekiq::Web => '/a/workers'
  end

  root :to => "home#index"
  get 'page/:page' => 'home#index'

end
