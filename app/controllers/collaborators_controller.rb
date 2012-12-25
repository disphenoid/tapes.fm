class CollaboratorsController < ApplicationController
  respond_to :json

  def show

    @collaborators = Tapedeck.find(params[:id]).all_collaborators

  end
  
  def destroy

    @tapedeck = Tapedeck.find(params[:id])
    

    @tapedeck.collaborator_ids.delete(Moped::BSON::ObjectId.from_string(params[:collaborator].to_s))
    @tapedeck.save

    @collaborator = Invite.find_by({invited_user_id: params[:collaborator], tapedeck_id: params[:id]}) 
    @collaborator.destroy

    # @collaborator = Tapedeck.find(params[:collaborator_id])
    
    render :json =>  @collaborator


  end

end
