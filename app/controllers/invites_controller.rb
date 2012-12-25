require 'digest'
class InvitesController < ApplicationController
  respond_to :json
  def index
    
  end

  

  def create

       
      #check if matches format of an email adresse
      if /^.+@.+$/xi.match(params[:value].to_s) 
          
          user = User.where({email: params[:value]}).first
          if user && !Invite.where({invited_id: user.id, tapedeck_id: params[:tapedeck_id] }).first && !tapedeck.collaborator_ids.include?(user.id)       
            invite = Invite.new

            invite.user_id = current_user.id
            invite.invited_id = user.id
            invite.tapedeck_id = params[:tapedeck_id]
            
            invite.save
          else

            email =  params[:value]          
            invite = Invite.find_or_initialize_by({email: email})
            invite.user_id = current_user.id 
            invite.tapedeck_id = params[:tapedeck_id] unless params[:tapedeck_id].blank?
            invite.invite_hash = Digest::MD5.hexdigest(params[:value].to_s)
            invite.save
            InviteMailer.invite(invite.id).deliver

          end 


      #else check if user exists and invite user.
      elsif params[:value]

        tapedeck = Tapedeck.find(params[:tapedeck_id]) 
        user = User.where({name: params[:value]}).first
      
        if user && !Invite.where({invited_id: user.id, tapedeck_id: tapedeck.id }).first && !tapedeck.collaborator_ids.include?(user.id)       
          invite = Invite.new

          invite.user_id = current_user.id
          invite.invited_id = user.id
          invite.tapedeck_id = tapedeck.id
          
          invite.save
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


