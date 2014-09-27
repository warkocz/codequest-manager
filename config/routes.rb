Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  root 'pages#index'

  get 'users/dashboard'

  resources :orders, only: [:new, :create, :edit, :update]
end
