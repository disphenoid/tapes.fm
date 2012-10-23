class ApplicationController < ActionController::Base
  protect_from_forgery

  def user
    


  end
  def after_sign_in_path_for(resource) 

    "/tapes"

  end 
end
