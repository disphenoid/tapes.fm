class InvitesController < ApplicationController
  respond_to :json
  def index
    
  end
  def create

      tapedeck = Tapedeck.find(params[:tapedeck_id])
      user = User.where({name: params[:value]}).first
      puts "####"+params[:value]
      
      if user
        tapedeck.collaborator_ids.push user.id
        tapedeck.save
      end
    
  end

end
