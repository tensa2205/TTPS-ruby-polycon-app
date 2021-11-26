Rails.application.routes.draw do
  resources :professionals
  resources :appointments
  root to: 'welcome#index'

  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
