class TapedeckController < ApplicationController
  respond_to :json
  def index
    render :json => Tapedeck.all
  end

  def show
    @tapedeck = Tapedeck.find(params[:id])
    #render :json => Tapedeck.find(params[:id]).to_json(:include => "tape", :include => {"tape" => {:include => "tracks"}})
  end

  def create

    @tapedeck = Tapedeck.new 
    @tapedeck.user_id = current_user.id
    @tapedeck.remixable = params[:remixable]
    @tapedeck.commentable = params[:commentable]
    @tapedeck.public = params[:public]
    @tapedeck.collaborator_ids.push current_user.id
    @tapedeck.name =  params[:name]
    @tapedeck.save


    render :json => @tapedeck
  end
  
  def update
    
    tapedeck = Tapedeck.find(params[:id])
    tapedeck.update_attributes!(params[:tapedeck])

    render :json => tapedeck

  end

  def destroy
    #respond_with Tapedeck.destroy(params[:id])
    render :json => Tapedeck.destroy(params[:id])
  end


end
