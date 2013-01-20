class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :only_if_logged 
  before_filter :user_json_v 
  layout :resolve_layout
  before_filter :check_week_limit
  before_filter :check_plan_expire


  def ping
    #returns ping for load balancer
    # render_to_string "dd", :layout => false
    render :json => 'pong', :layout => false

  end

  def check_plan_expire
    if current_user

      unless current_user.plan_id == 1 || current_user.plan_id.blank?

        if current_user.plan_expire && current_user.plan_expire <= Date.today
          
          current_user.plan_id = 1
          current_user.plan_expire = nil
          current_user.save 
          
        end 

      else
        
        # current_user.plan_expire = nil
        # current_user.plan_id = 1
        # current_user.save

      end


    end

  end

  def check_week_limit

    if current_user

      unless current_user.minute_reset.blank?
        
        if current_user.minute_reset <= Date.today
          current_user.current_uploadtime = 0
          current_user.minute_reset = (Date.today)+ 7
          current_user.save
        end

      else

        current_user.minute_reset = (Date.today + 7)
        current_user.current_uploadtime = 0
        current_user.save

      end

    end

    

  end


  def user_json_v


    #@user_json22 =  
      
    #render_to_string( template: 'users/_user', locals: { user: current_user})
    #json.partial! "users/user.json.jbuilder", user: current_user


    if current_user
      @user_j = Jbuilder.encode do |json|

        json.(current_user, :id,:_id, :name, :plan_id, :current_uploadtime, :total_uploadtime, :created_at)


        json.projects(current_user.projects) do |json, project|
          
          json.(project,:id, :name)
          json.users(project.users, :name)


        end

        #@user_j = json.partial! "users/user.json.jbuilder", user: current_user
      end
    else
      @user_j = nil
    end
  end

  def after_sign_in_path_for(resource) 

    "/dashboard"

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
      when "/ping"
        nil
      else
        "application"
    end
  end
end
