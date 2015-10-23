Rails.application.routes.draw do

  get 'password_resets/new'

  get 'password_resets/edit'

  resources :users
  resources :account_activations , only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]

  get 'home' => 'static_pages#home'
  get 'help' => 'static_pages#help'
  get 'about' => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  get 'signup' => 'users#new'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'static_pages#home'


end
