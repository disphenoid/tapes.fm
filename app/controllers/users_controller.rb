class UsersController < ApplicationController
  def user_name_unique
    
    
    unique = params[:name]
    user = User.find_by({name: /^#{params[:name]}$/i}) rescue nil
    
    unique = user.blank?
      

    render :json => "{unique: #{unique}}"

    
  end

end
