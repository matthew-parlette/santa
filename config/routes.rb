Rails.application.routes.draw do
  resources :assignments, param: :year, only: [:index, :show]
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  root to: "user#index"

  resources :users do
    resources :assignment, only: [:index, :show], controller: "assignments", param: :year
  end
end
