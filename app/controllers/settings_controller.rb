class SettingsController < ApplicationController


  def update

      
      current_user.update_attributes!(params)


      render :json => current_user
    
  end



  def update_picture

    current_user.picture = params[:user][:picture] 

    if current_user.save 
      render :json => current_user
    end
    
  end



end
