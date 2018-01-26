Rails.application.routes.draw do

	root 'static_pages#home'
	get  '/help',    to: 'static_pages#help'
	get  '/about',   to: 'static_pages#about'
	get  '/contact', to: 'static_pages#contact'
	
	get  '/signup',  to: 'users#new'
	post '/signup',  to: 'users#create'		# Adding a signup route responding to POST requests for unsubmitted signup form
	resources :users


	# HTTP request	URL		Named route		Action		Purpose
	# GET					/login	login_path		new				page for a new session (login)
	#	POST				/login	login_path		create		create a new session (login)
	#	DELETE			/logout	logout_path		destroy		delete a session (log out)
	get    '/login',   to: 'sessions#new'
	post   '/login',   to: 'sessions#create'
	delete '/logout',  to: 'sessions#destroy'

  resources :account_activations, only: [:edit]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
