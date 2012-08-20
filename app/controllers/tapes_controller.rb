class TapesController < ApplicationController

  def index
    render :json => Tape.all
  end

  def show
    render :json => Tape.find(params[:id]).to_json(:include => "tracks")
  end

  def create
    entry = Tape.create! params
    render :json => entry
  end
  
  def update
    tape = Tape.find(params[:id])
    tape.update_attributes!(params[:tape])
    render :json => tape
  end

  def destroy
    #respond_with Tapedeck.destroy(params[:id])
    render :json => Tape.destroy(params[:id])
  end

end
