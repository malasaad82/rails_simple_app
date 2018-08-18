Rails.application.routes.draw do

  get 'password_resets/new'
  get 'password_resets/edit'

	root 'static_pages#home'
	get  '/help',    to: 'static_pages#help'
	get  '/about',   to: 'static_pages#about'
	get  '/contact', to: 'static_pages#contact'

	get  '/signup',  to: 'users#new'
	post '/signup',  to: 'users#create'		# Adding a signup route responding to POST requests for unsubmitted signup form
	resources :users


  resources :listings do
    resource :like, :only => [:create, :destroy]
  end

  resources :employeeships, only: [:create, :destroy, :update]


	# HTTP request	URL		Named route		Action		Purpose
	# GET					/login	login_path		new				page for a new session (login)
	#	POST				/login	login_path		create		create a new session (login)
	#	DELETE			/logout	logout_path		destroy		delete a session (log out)
	get    '/login',   to: 'sessions#new'
	post   '/login',   to: 'sessions#create'
	delete '/logout',  to: 'sessions#destroy'

  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
