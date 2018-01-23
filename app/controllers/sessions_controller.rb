class SessionsController < ApplicationController
	def new
  end

  def create
    # @user For using an instance variable in the create action
  	# Pulls the user out of the database using the submitted email address
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
      # log_in => Helper in sessions_helper.rb
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_to @user      
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