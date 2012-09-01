class WebappController < ApplicationController
  layout :resolve_layout

  def index
  end
  def tapedeck 
    @track = Track.new
    @tapedeck = Tapedeck.find(params[:id]) #.to_json(:include => "tapes",:include => "tape", :include => {"tape" => {:include => "tracks"}}) 


    @json = render_to_string( template: 'tapedeck/show.json.jbuilder', locals: { tapedeck: @tapedeck})

    respond_to do |format|
        format.html
    end


  end
  def login
  end

  def uploadtest
    @track = Track.new
  end

  def upload
    #handle upload
    # track = Track.new
    # track.asset = params[:track][:asset]
    # track.save
    # redirect_to "/"

    #track.asset = params[]
    #
    newparams = coerce(params)
    @track = Track.new(newparams[:track])
    #@track.name = params[:name]

    #@tape = Tape.find(params[:tape_id])
    
    # unless @tape.open
    # #copy tape
    #   @new_tape =  Tape.new
    #   @new_tape.tapedeck_id = @tape.tapedeck_id
    #   @new_tape.track_ids = @tape.track_ids
    #   @new_tape.genre = @tape.track_ids
    #   @new_tape.track_ids = @tape.track_ids 

    #   @new_tape.track_ids.push(@track.id)
    #   @new_tape.save
    #   @tapedeck = Tapedeck.find(@new_tape.tapedeck_id)
    #   @tapedeck.active_tape_id = @new_tape.id
    #   @tapedeck.save
    # else
    #   @tape.track_ids.push(@track.id) 
    #   @tape.save
    # end

    

    respond_to do |format|
      if @track.save 
        # format.html { redirect_to @picture, notice: 'Picture was successfully created.' }
        # format.js { @picture.id }
        return  true
      else
        #format.html { redirect_to "/" }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end


  end


  def resolve_layout
    case action_name
    when "login"
      "application"
    else
      "application"
    end
  end

  private 
  def coerce(params)
    if params[:track].nil? 
      h = Hash.new 
      h[:track] = Hash.new       
      h[:track][:asset] = params[:Filedata] 
      # h[:picture][:image].content_type = MIME::Types.type_for(h[:picture][:image].original_filename).to_s
      h
    else 
      params
    end 
  end


end
