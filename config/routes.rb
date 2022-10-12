Rails.application.routes.draw do
  resources :levels
  namespace :authentication, path: '', as: ''  do
    resources :users, only: [:new, :create]
    resources :sessions, only: [:new, :create, :destroy]
  end  


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
