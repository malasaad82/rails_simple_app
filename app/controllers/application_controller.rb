class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  # temporary cookies created using the session method are automatically encrypted  
  # Permanent cookies are vulnerable to a session hijacking attack
  include SessionsHelper


  # Confirms a logged-in user.  To use it for both users and listings controller
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end


end
