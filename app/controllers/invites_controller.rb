class InvitesController < ApplicationController
  respond_to :json
  def index
    
  end

  

  def create

       
      tapedeck = Tapedeck.find(params[:tapedeck_id]) 
      user = User.where({name: params[:value]}).first
      
      if params[:value] && user
      
        if user && !Invite.where({invited_id: user.id, tapedeck_id: tapedeck.id }).first && !tapedeck.collaborator_ids.include?(user.id)       
          invite = Invite.new

          invite.user_id = current_user.id
          invite.invited_id = user.id
          invite.tapedeck_id = tapedeck.id
          
          invite.save
        end

      elsif params[:value]
          
        if /^.+@.+$/xi.match(params[:value].to_s)

          email =  params[:value]          
          invite = Invite.find_or_initialize_by({email: email})

        end

      end
    
  end



  def update

    @invite = Invite.find(params[:id])
    @invite.update_attributes!(params[:invite])
    @invite.tapedeck.collaborator_ids.push @invite.invited_id
    @invite.tapedeck.save


    render :json => @invite 

  end
  def destroy

    render :json => Invite.find(params[:id]).destroy() 

  end

end


