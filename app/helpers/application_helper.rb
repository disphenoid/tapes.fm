module ApplicationHelper

  def current_user_json
      
    current_user.to_json
    #render_to_string( template: 'users/user', locals: { user: current_user})
  end


end
