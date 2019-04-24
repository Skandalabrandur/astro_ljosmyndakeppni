Rails.application.routes.draw do
		resources :posts
		resources :users
		resources :sessions, only: [:new, :create, :destroy]
		# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
		
		
		get 'sessions/new'
		get 'sessions/create'
		get 'sessions/destroy'
		
		#get 'signup', to: 'users#new', as: 'signup'
		get 'login', to: 'sessions#new', as: 'login'
		get 'admin', to: 'sessions#new', as: 'admin'
		get 'logout', to: 'sessions#destroy', as: 'logoutings'
		get '/error', to: 'users#error', as: 'error'
		get '/rate/:postid/:rating', to: 'posts#rate', as: 'rating'
		get '/image/:id/:email/', constraints: { email: /[^\/]+/}, to: 'posts#user_show'
		get '/passwordchange/', to: 'users#change_password'
	        get '/passwordchagne/', to: 'users#change_password'
		post '/passwordchanging/', to: 'users#change_password_post'
		
		root 'posts#user_start_page'

		#get '*path', to: 'users#error'
  		get '*path', to: 'users#error', constraints: lambda { |req|
	    		req.path.exclude? 'rails/active_storage'
  		}
		
		#root 'posts#start_page'
end
