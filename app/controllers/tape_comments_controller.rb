class TapeCommentsController < ApplicationController
  respond_to :json
  def show
      
    @comments = Comment.where({tape_id: params[:id], tapedeck_id: params[:tapedeck], track_id: nil})

  end
end
