class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :only_if_logged 

  def user
    
  end
  def after_sign_in_path_for(resource) 

    "/tapes"

  end 

  def only_if_logged

    #puts "#########################" + request.path
    #redirect_to(root_path) unless !current_user && request.path == "/" || request.path == "/login"

  end


end
