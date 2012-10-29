class HomeController < ApplicationController
  layout "splash"
  def index
    redirect_to("/tapes") if current_user 
  end
end
