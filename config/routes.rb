Rails.application.routes.draw do
  devise_for :users
  root "events#index"

  resources :events
  resources :users, only: [:show, :edit, :update]
  resources :events do
    resources :comments, only: [:create, :destroy]
    resources :subscriptions, only: [:create, :destroy]
    resources :photos, only: [:create, :destroy]
    post :show, on: :member
  end
end
