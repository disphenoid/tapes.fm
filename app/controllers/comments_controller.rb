class CommentsController < ApplicationController
  
  respond_to :json

  def index
    @comments = Comment.all(:limit => 5)
  end

  def show
    @comments = nil#Comment.find({ tapedeck_id: params[:id] })
  end

  def create
    entry = Comment.new params[:comment]
    entry.user_id = current_user.id
    entry.save
    render :json => entry
  end
  
  def update
    comment = Comment.find(params[:id])
    comment.update_attributes!(params[:comment])
    render :json => comment
  end

  def destroy
    #respond_with Tapedeck.destroy(params[:id])
    render :json => Comment.find(params[:id]).destroy()
  end

end
