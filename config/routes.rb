Rails.application.routes.draw do
  resources :assignments, param: :year, only: [:index, :show]
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  root to: "user#show"

  resources :users, controller: "user" do
    resources :assignment, only: [:index, :show], controller: "assignments", param: :year
  end
end
