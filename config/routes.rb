Rails.application.routes.draw do
  resources :assignments, param: :year, only: [:index, :show]
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    patch 'users' => 'devise/registrations#update', :as => 'user_registration'
  end

  root to: "user#show"

  resources :users, controller: "user" do
    resources :assignment, only: [:index, :show], controller: "assignments", param: :year
    resources :ideas
  end
end
