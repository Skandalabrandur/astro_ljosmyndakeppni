Rails.application.routes.draw do
  resources :posts
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  get 'admin/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
  
  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logoutings'
  get '/error', to: 'users#error', as: 'error'
  get '/home', to: 'posts#user_start_page', as: 'user_start_page'
  get '/rate/:postid/:rating', to: 'posts#rate', as: 'rating'

  root 'posts#user_start_page'
end
