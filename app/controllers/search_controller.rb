class SearchController < ApplicationController
  def index
  
    if params[:q]
      
      query = params[:q].split(" ")
      a = Autocomplete.new "tape_tags_complete"
      @complete = a.complete params[:q]

      @tags = query + @complete

      @tapedecks =  Tapedeck.tagged_with(@tags).limit(5)
      
      if query.count == 1
        
        @users = User.where({name: /^#{query.first}$/i}) 
      else
        @users = []

      end

    end

  end
end
