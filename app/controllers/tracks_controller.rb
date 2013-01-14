class TracksController < ApplicationController
    def index
    render :json => Track.all
  end

  def show
    render :json => Track.find(params[:id]).to_json(:include => "tracks")
  end

  def create

    if current_user
      if(entry = (Track.create! params))
        
        current_user.add_time entry.duration

      end

      render :json => entry
    end
  end
  
  def update
    if current_user
      tape = Track.find(params[:id])
      tape.color = params[:color]
      tape.name = params[:name]
      tape.update_attributes!(params[:track])
      render :json => tape
    end
  end

  def destroy
    #respond_with Tapedeck.destroy(params[:id])
    if current_user
      render :json => Track.destroy(params[:id])
    end
  end
end
