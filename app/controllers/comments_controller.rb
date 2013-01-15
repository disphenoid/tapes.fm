class CommentsController < ApplicationController
  
  respond_to :json

  def index
    @comments = Comment.all(:limit => 5)
  end

  def show
    @comments = nil#Comment.find({ tapedeck_id: params[:id] })
  end

  def create
    if current_user 
      entry = Comment.new params[:comment]
      entry.user_id = current_user.id
      if entry.save
        
        current_user.push_activity "comment", entry 

      end
      render :json => entry
    end
  end
  
  def update
    if current_user
      comment = Comment.find(params[:id])
      comment.update_attributes!(params[:comment])
      render :json => comment
    end
  end

  def destroy
    #respond_with Tapedeck.destroy(params[:id])
    @comment = Comment.find(params[:id])
    if current_user
      render :json => @comment.destroy()
    end

  end

end
