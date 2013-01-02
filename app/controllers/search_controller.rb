class SearchController < ApplicationController
  def index
  
    if params[:q]
      
      query = params[:q].split(" ")

      @tapedecks =  Tapedeck.tagged_with(query).limit(5)
      
      if query.count == 1
        
        @users = User.where({name: /^#{query.first}$/i}) 
      else
        @users = []

      end

    end

  end
end
