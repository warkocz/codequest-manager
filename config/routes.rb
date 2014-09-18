Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root 'pages#index'

  resources :users, only: [:edit, :update] do
    get :dashboard, on: :collection
  end

  resources :orders, except: [:destroy] do
    resources :dishes, except: [:show] do
      get :copy, on: :member
    end
    member do
      put :change_status
      get :shipping
      put :finalize
    end
  end
end
