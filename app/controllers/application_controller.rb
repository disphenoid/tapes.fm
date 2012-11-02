class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :only_if_logged 
  before_filter :user_json_v 
  layout :resolve_layout



  def user_json_v


    #@user_json22 =  
      
    #render_to_string( template: 'users/_user', locals: { user: current_user})
    #json.partial! "users/user.json.jbuilder", user: current_user


    @user_j = Jbuilder.encode do |json|

      json.(current_user, :id,:_id, :name, :created_at)
      json.projects(current_user.projects) do |json, project|
        
        json.(project,:id, :name)
        json.users(project.users, :name)

      end

      #@user_j = json.partial! "users/user.json.jbuilder", user: current_user
    end
    
  end

  def after_sign_in_path_for(resource) 

    "/tapes"

  end 

  def only_if_logged

    #puts "#########################" + request.path
    #redirect_to(root_path) unless !current_user && request.path == "/" || request.path == "/login"

  end
  def resolve_layout
    case request.path 
      when "/login"
        "splash"
      when "/"
        "splash"
      else
        "application"
    end
  end
end
