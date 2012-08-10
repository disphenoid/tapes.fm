class TapedeckController < ApplicationController
    respond_to :json

  def index
    respond_with Tapedeck.all
  end

  def show
    @tapedeck = Tapedeck.find(params[:id]) 
    respond_with @tapedeck.to_json(:include => "tape")
  end

  def create
    entry = Tapedeck.create! params
    render :json => entry
  end
  
  def update
    #respond_with Tapedeck.update(params[:id], params[:tape])
    #respond_with Tapedeck.where(_id: params[:id]).update(params[:tapedeck])
    tapedeck = Tapedeck.find(params[:id])
    tapedeck.update_attributes!(params[:tapedeck])
    render :json => tapedeck
  end

  def destroy
    #respond_with Tapedeck.destroy(params[:id])
    render :json => Tapedeck.destroy(params[:id])
  end


end
