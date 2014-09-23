Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}
  root 'pages#index'

  authenticate :user, lambda { |u| u.admin? } do
    mount Upmin::Engine => '/admin'
  end

  resources :users, only: [:edit, :update] do
    resources :transfers, only: [:new, :create]
    get :dashboard, on: :collection
    get :my_balances, on: :member
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
