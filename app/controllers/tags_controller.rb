class TagsController < ApplicationController
  
  respond_to :json 
  
  def show
    
    a = Autocomplete.new "tape_tags_complete"
    @tags = a.complete params[:id]

  end



end
