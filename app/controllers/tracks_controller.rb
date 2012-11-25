class TracksController < ApplicationController
    def index
    render :json => Track.all
  end

  def show
    render :json => Track.find(params[:id]).to_json(:include => "tracks")
  end

  def create

    if(entry = (Track.create! params))
      
      current_user.add_time entry.duration

    end

    render :json => entry
  end
  
  def update
    tape = Track.find(params[:id])
    tape.update_attributes!(params[:track])
    render :json => tape
  end

  def destroy
    #respond_with Tapedeck.destroy(params[:id])
    render :json => Track.destroy(params[:id])
  end
end
