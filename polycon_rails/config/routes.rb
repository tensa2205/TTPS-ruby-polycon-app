Rails.application.routes.draw do
  root to: 'welcome#index'
  resources :professionals do
    resources :appointments #Recurso anidado en profesionales.
  end

  resources :users
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
end
