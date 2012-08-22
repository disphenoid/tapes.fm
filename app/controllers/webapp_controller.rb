class WebappController < ApplicationController
  layout :resolve_layout

  def index
  end
  def tapedeck 
    @json = Tapedeck.find(params[:id]).to_json(:include => "tape", :include => {"tape" => {:include => "tracks"}}) 

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
    if params[:picture].nil? 
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
