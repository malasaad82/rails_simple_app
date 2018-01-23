class SessionsController < ApplicationController
	def new
  end

  def create
  	# Pulls the user out of the database using the submitted email address
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
      # log_in => Helper in sessions_helper.rb
      log_in user
      redirect_to user      
    else
      # Create an error message.
      flash.now[:danger] = 'Invalid email/password combination' # Not quite right!      
      render 'new'
    end

  end

  def destroy
  	log_out
    redirect_to root_url
  end
end
