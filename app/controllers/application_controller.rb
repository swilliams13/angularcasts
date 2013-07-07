class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # We'll just use this as a launch point for our App
  def index
    render :layout => 'application', :nothing => true
  end
  
end
