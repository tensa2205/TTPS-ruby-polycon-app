Rails.application.routes.draw do
  root to: 'welcome#index'
  resources :professionals do
    get "export_appointments", to: "export#export_professional"
    resources :appointments #Recurso anidado en profesionales.
  end

  resources :users
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get "export_all", to: "export#export_all"
end
