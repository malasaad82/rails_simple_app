class SessionsController < ApplicationController
	def new
  end

  def create
    # @user For using an instance variable in the create action
  	# Pulls the user out of the database using the submitted email address
    # @user = User.find_by(email: params[:session][:email].downcase)
    # if @user && @user.authenticate(params[:session][:password])
    #   log_in @user
    #   params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
    #   redirect_back_or @user   
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or @user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end    
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