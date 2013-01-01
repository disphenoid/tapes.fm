class TagsController < ApplicationController
  
  respond_to :json 
  
  def index
    
    a = Autocomplete.new "tape_tags_complete"
    @tags = a.complete params[:term]

    render :json => @tags.to_json

  end



end
