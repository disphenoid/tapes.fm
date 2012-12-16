class RequestsController < ApplicationController
  respond_to :json
  def create
      
    if params[:email]
      r = Request.find_or_initialize_by({:email => params[:email]})
      unless r.created_at
        r.email = params[:email] if params[:email] 
        r.url = params[:url] if params[:url] 
        r.from = params[:from] if params[:from] 
        r.ip = request.remote_ip 
        r.user_agent = request.headers["HTTP_USER_AGENT"] 
        r.origin = request.headers["HTTP_ORIGIN"] 
        r.language = request.headers["HTTP_ACCEPT_LANGUAGE"] 
        r.save
        flash[:notice] = "Thank you! You will hear soon from us!"
      else
        flash[:alert] = "You are already on the List, thank you!"
      end 
    end

    redirect_to "/"

  end

end
