class TapedeckController < ApplicationController
  respond_to :json
  protect_from_forgery :except => [:update_cover]


  def index
    render :json => Tapedeck.all
  end

  def show
    @tapedeck = Tapedeck.find(params[:id])
    #render :json => Tapedeck.find(params[:id]).to_json(:include => "tape", :include => {"tape" => {:include => "tracks"}})
  end

  def create

    @tapedeck = Tapedeck.new 
    @tapedeck.user_id = current_user.id
    @tapedeck.genre = params[:genre]
    @tapedeck.remixable = params[:remixable]
    @tapedeck.collaborator_ids.push current_user.id
    @tapedeck.tags = params[:tags]

    if params[:project_id]
      @tapedeck.project_id = params[:project_id] 
    end
    @tapedeck.commentable = params[:commentable]
    
    @tapedeck.private = params[:private]
    @tapedeck.name =  params[:name]
    @tapedeck.save


    render :json => @tapedeck
  end
  
  def update
    
    @tapedeck = Tapedeck.find(params[:id])
    if @tapedeck.update_attributes!(params[:tapedeck])
      if params[:tags]
        addTagsToAutocomplete params[:tags]
      end

    end

    render :json => @tapedeck

  end


  def update_cover

    @tapedeck = Tapedeck.find_or_initialize_by({:id => params[:id]})
    @tapedeck.cover = Cover.new
    @tapedeck.cover.image = params[:tapedeck][:cover]
    @tapedeck.collaborator_ids.push current_user.id
    @tapedeck.user_id = current_user.id


    if @tapedeck.cover.save && @tapedeck.save

      # render :json => @tapedeck
    end
    
  end

  def destroy
    #respond_with Tapedeck.destroy(params[:id])
    render :json => Tapedeck.find(params[:id]).destroy()
  end

  private
  
  def addTagsToAutocomplete tags

    a = Autocomplete.new "tape_tags_complete"
    tags.each do |tag|
      
      a.add tag
      
    end
    
  end

end
