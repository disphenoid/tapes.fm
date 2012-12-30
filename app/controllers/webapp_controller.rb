require 'rubygems'
require 'fog'
require 'waveinfo'
require 'fileutils'

class WebappController < ApplicationController
  #skip_before_filter :verify_authenticity_token
  protect_from_forgery :except => [:upload, :upload_track]

  def index
  end
  
  def signup

    unless current_user || params[:invite].blank?

      @invites = Invite.where({invite_hash: params[:invite]})

      if @invites.count > 0 && @invites.last.invited_user_id == nil
        @invite = @invites.last 

        @json = render_to_string( template: 'signup/index.json.jbuilder', locals: { invite: @invite}) 

        respond_to do |format|
            format.html
        end   

        
      else

        redirect_to "/"

      end
        
      
    else

        redirect_to "/"

    end

 
    
    
  end


  def download 
    
    expires = Time.now + 5.minutes
    
    track = Track.find(params[:id])

    redirect_to s3_signed_url(ENV['s3_bucket_name'], "tracks/#{params[:id]}/#{params[:id]}.#{params[:type]}",'GET',nil,nil, {'response-content-disposition' => "attachment; filename=#{track.name}.#{params[:type]}"})


    #url += "AWSAccessKeyId=#{"AKIAJLUDMFIAAGNUJOIQ"}&Expires=#{expires.to_i}&Signature=#{CGI.escape(signature)}";
    #return url


  end

  def settings

      @json = render_to_string( template: 'settings/index.json.jbuilder', locals: { settings: current_user}) 



      respond_to do |format|
          format.html
      end    
  end


  def user

      if params[:id]
        @user = User.find(params[:id])
      else
        @user = User.find_by({name: /^#{params[:name]}$/i})
       
      end

      if current_user
        @tapedecks = Tapedeck.where({collaborator_ids: @user.id}).desc(:created_at) #Tapedeck.where({user_id: current_user.id})
      else
        @tapedecks = [] 
      end

      @json = render_to_string( template: 'user/index.json.jbuilder', locals: { tape: @tapedecks}) 

      respond_to do |format|
          format.html
      end
  end


  def dashboard
      if current_user
      
        @tapedecks = Tapedeck.where({collaborator_ids: current_user.id}).sort({updated_at:-1}).limit(5) #Tapedeck.where({user_id: current_user.id})

        @invites = Invite.where({accepted: false,invited_user_id: current_user.id}).excludes(:tapedeck_id => nil) #Tapedeck.where({user_id: current_user.id})
        
        @activities = current_user.stream


      else
        @tapedecks = [] 
        @invites = [] 
        @activities = [] 
      end
      
      @json = render_to_string( template: 'dashboard/index.json.jbuilder', locals: { tape: @tapedecks, invite: @invites, activities: @activities })

      respond_to do |format|
          format.html
      end

  end
  def explore


      @active = Tapedeck.where({public: true}).where(:version_count.ne => 1).sort({updated_at:-1})
      @top = Tapedeck.all
      @new = Tapedeck.where({public: true}).where(:version_count.in => [0,1]).desc(:created_at)

       @json = render_to_string( template: 'explore/index.json.jbuilder', locals: { top: @top, active: @active, new: @new }) 

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
          current_user.add_time @track.duration
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
          current_user.add_time @track.duration
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

  ### Admin 
  
  def admin_users

    
    # prepend_view_path "app/views/admin/users"

    @users = User.all.limit(50)
    @user_count = User.count
    @invites = Invite.all.excludes(:user_id => nil).limit(50)
    @invite_count = Invite.count
    @requests = Request.all.limit(50)
    @request_count = Request.count

    @json = render_to_string( template: 'admin/users/index.json.jbuilder', locals: { users: @users, invites: @invites, requests: @requests}) 
    
    respond_to do |format|
      format.html
      
      # render :partial => 'admin/users/index.html.erb', :formats => [:html]

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
