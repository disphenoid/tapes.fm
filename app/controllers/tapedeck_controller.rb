class TapedeckController < ApplicationController

  def index
    render :json => Tapedeck.all
  end

  def show
    render :json => Tapedeck.find(params[:id]).to_json(:include => "tape", :include => {"tape" => {:include => "tracks"}})
  end

  def create
    entry = Tapedeck.create! params
    render :json => entry
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
