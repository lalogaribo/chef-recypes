Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'pages#home'
  resources :recipes do
    resources :comments, only: [:create]
  end
  get '/signup', to: 'chefs#new'
  resources :chefs, except: [:new]
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :ingredients, except: [:destroy]
end
