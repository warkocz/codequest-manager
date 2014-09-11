Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root 'pages#index'

  resources :users, only: [:edit, :update] do
    get :dashboard, on: :collection
  end

  resources :orders, only: [:new, :create, :edit, :update] do
    resources :dishes, except: [:show] do
      get :copy, on: :member
    end
    put :change_status, on: :member
  end
end
