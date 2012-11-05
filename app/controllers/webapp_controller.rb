require 'rubygems'
require 'fog'
require 'waveinfo'
require 'fileutils'

class WebappController < ApplicationController
  #skip_before_filter :verify_authenticity_token
  protect_from_forgery :except => [:upload, :upload_track]

  def index
  end
  
  def download 
    
    expires = Time.now + 5.minutes
    
    track = Track.find(params[:id])

    redirect_to s3_signed_url("tapes.fm", "tracks/#{params[:id]}/#{params[:id]}.#{params[:type]}",'GET',nil,nil, {'response-content-disposition' => "attachment; filename=#{track.name}.#{params[:type]}"})


    #url += "AWSAccessKeyId=#{"AKIAJLUDMFIAAGNUJOIQ"}&Expires=#{expires.to_i}&Signature=#{CGI.escape(signature)}";
    #return url


  end
  
  def dashboard
      if current_user
      
        @tapedecks = Tapedeck.where({collaborator_ids: current_user.id}).limit(4).sort({created_at:-1}) #Tapedeck.where({user_id: current_user.id})
        @invites = Invite.where({accepted: false,invited_id: current_user.id}) #Tapedeck.where({user_id: current_user.id})
      else
        @tapedecks = [] 
        @invites = [] 
      end
      
      @json = render_to_string( template: 'dashboard/index.json.jbuilder', locals: { tape: @tapedecks, invite: @invites })

      respond_to do |format|
          format.html
      end

  end
  def explore

      respond_to do |format|
          format.html
      end

  end

  def tapes

      if current_user
        @tapedecks = Tapedeck.where({collaborator_ids: current_user.id}).desc(:created_at) #Tapedeck.where({user_id: current_user.id})
      else
        @tapedecks = [] 
      end

      @json = render_to_string( template: 'tapes/index.json.jbuilder', locals: { tape: @tapedecks}) 
      respond_to do |format|
          format.html
      end

  end


  def tapedeck 
    @track = Track.new

    if params[:id]
      @tapedeck = Tapedeck.find(params[:id]) 

      @json = render_to_string( template: 'tapedeck/show.json.jbuilder', locals: { tapedeck: @tapedeck}) 
      respond_to do |format|
          format.html
      end
    end


  end


  def login
  end



  def upload

    @tapedeck = Tapedeck.find(params[:tapedeck_id])
    if current_user && (@tapedeck.collaborator?(current_user))
      newparams = coerce(params)

      @track = Track.new(newparams[:track]) 
      @track.group = @track.id
      @track.user_id = current_user.id

      @track.color = (params[:track_length].to_i + 1) 

      #puts "paraaaams #{newparams[:track][:asset].class}"
      #@track.process_asset_upload = true 

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

  end

  def upload_track

    @tapedeck = Tapedeck.find(params[:tapedeck_id])

    if current_user && (@tapedeck.collaborator?(current_user))
      newparams = coerce(params)

      @track = Track.new(newparams[:track]) 

      @old_track = Track.find(params[:old_track])
      @track.user_id = current_user.id
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
  def s3_signed_url(bucket, pathname, verb, content_md5=nil, content_type=nil, response_headers = {})
    expires = Time.now + 5.minutes
    response_headers_canonicalized = response_headers.sort_by{|key, value| key.downcase}.collect{|key, value| "#{key}=#{value}"}.join("&").to_s
    string_to_sign = "#{verb.upcase}\n#{content_md5}\n#{content_type}\n#{expires.to_i}\n/#{bucket}/#{pathname}?#{response_headers_canonicalized}"

      digest = OpenSSL::Digest::Digest.new('sha1')
    hmac = OpenSSL::HMAC.digest(digest, "cfuOIImdhf0xSfydV2c6h2tstQKi1oY/inJ6sAJ1", string_to_sign)
    signature = Base64.encode64(hmac).chomp
    url = "http://s3.amazonaws.com/#{bucket}/#{pathname}?"
    if response_headers.count > 0
      response_headers.each do |key, value|
        url += "#{key}=#{value}&"
      end
    end
    url += "AWSAccessKeyId=#{"AKIAJLUDMFIAAGNUJOIQ"}&Expires=#{expires.to_i}&Signature=#{CGI.escape(signature)}";
    return url
  end

end
