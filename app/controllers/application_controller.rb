class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  # temporary cookies created using the session method are automatically encrypted  
  # Permanent cookies are vulnerable to a session hijacking attack
  include SessionsHelper
end
