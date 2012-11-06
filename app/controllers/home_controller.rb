class HomeController < ApplicationController
  layout "splash"
  def index
    redirect_to("/dashboard") if current_user 
  end
end
