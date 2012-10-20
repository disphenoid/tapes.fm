class TrackCommentsController < ApplicationController
  respond_to :json
  def show
      
    @comments = Comment.where({track_id: params[:id], tapedeck_id: params[:tapedeck]})

  end
end
