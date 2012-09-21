require 'rubygems'
require 'fog'
require 'waveinfo'
require 'fileutils'

class WebappController < ApplicationController
  layout :resolve_layout
  #skip_before_filter :verify_authenticity_token

  def index
  end
  def tapedeck 
    @track = Track.new

    if params[:id]
      @tapedeck = Tapedeck.find(params[:id]) #.to_json(:include => "tapes",:include => "tape", :include => {"tape" => {:include => "tracks"}}) 

    @json = render_to_string( template: 'tapedeck/show.json.jbuilder', locals: { tapedeck: @tapedeck}) 
    respond_to do |format|
        format.html
    end
    end


  end
  def login
  end



  def upload

    newparams = coerce(params)

    @track = Track.new(newparams[:track]) 
    @track.group = @track.id
    #puts "paraaaams #{newparams[:track][:asset].class}"
    #@track.process_asset_upload = true

    @track.color = (params[:track_length].to_i + 1) 
    

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

  def upload_track

    newparams = coerce(params)

    @track = Track.new(newparams[:track]) 

    @old_track = Track.find(params[:old_track])
    @track.group = @old_track.group 
    @track.color = @old_track.color 
    @replace_id = params[:old_track] 
    

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
