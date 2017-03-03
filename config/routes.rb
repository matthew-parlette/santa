Rails.application.routes.draw do
  devise_for :users
  root to: 'application#index'
  get 'admin', to: 'application#admin'
end
