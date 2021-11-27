Rails.application.routes.draw do
  root to: 'welcome#index'
  resources :professionals do
    resources :appointments #Recurso anidado en profesionales.
  end

  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
