class SettingsController < ApplicationController


  def update

      
      current_user.update_attributes!(params)


      render :json => current_user
    
  end



  def update_picture

    #current_user = Tapedeck.find_or_initialize_by({:id => params[:id]})
    current_user.picture = params[:user][:picture]
    #current_user.collaborator_ids.push current_user.id
    #current_user.user_id = current_user.id


    if current_user.save

      render :json => current_user
    end
    
  end



end
