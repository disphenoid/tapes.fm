require 'rubygems'
require 'fog'
require 'waveinfo'
require 'fileutils'

class WebappController < ApplicationController
  #skip_before_filter :verify_authenticity_token
  protect_from_forgery :except => [:upload, :upload_track]


  def information
  end

  def index
  end

  def upgrade
    @geoip ||= GeoIP.new("#{Rails.root}/db/GeoIP.dat")   
    remote_ip = request.remote_ip 
    if remote_ip != "127.0.0.1" #todo: check for other local addresses or set default value
      location_location = @geoip.country(remote_ip)
      if location_location != nil     
        @c = location_location[3]
      else
      end
    else
      @c = "LOCAL"
    end

    # puts "##################" + location_location[3].to_s
    @eu = ( @c == "LOCAL" || 
            @c == "AD" || 
            @c == "AT" || 
            @c == "BE" || 
            @c == "CY" || 
            @c == "EE" || 
            @c == "FI" || 
            @c == "FR" || 
            @c == "DE" || 
            @c == "GR" || 
            @c == "IE" || 
            @c == "IT" || 
            @c == "LU" || 
            @c == "MT"  
          )

    @json = {:eu => @eu, 
      :price_2 => (@eu ? Plan.info(2)[:price_eu_anual] : Plan.info(2)[:price_us_anual]), 
      :price_3 => (@eu ? Plan.info(3)[:price_eu_anual] : Plan.info(3)[:price_us_anual]), 
      :price_4 => (@eu ? Plan.info(4)[:price_eu_anual] : Plan.info(4)[:price_us_anual]) 
      }
    


    respond_to do |format|
          format.html
  end

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
    if current_user
      expires = Time.now + 5.minutes
      track = Track.find(params[:id])
      audio = track.audio 

      if track
        # this could potentially generate a lot of load for the db
        moment = DateTime.now
        DownloadStat.create(:moment => moment, :type => params[:type], :user => current_user.id)
        redirect_to s3_signed_url(ENV['s3_bucket_name'], "audio/#{audio.id}/#{audio.id}.#{params[:type]}",'GET',nil,nil, {'response-content-disposition' => "attachment; filename=#{track.name}.#{params[:type]}"})

      end
    end
    #url += "AWSAccessKeyId=#{"AKIAJLUDMFIAAGNUJOIQ"}&Expires=#{expires.to_i}&Signature=#{CGI.escape(signature)}";
    #return url
  end

  def settings
    if current_user
      @json = render_to_string( template: 'settings/index.json.jbuilder', locals: { settings: current_user})
      respond_to do |format|
          format.html
      end
    else
      redirect_to "/"
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

      if @tapedecks.count == 0
        @noob = true
      else
        @noob = false
      end

    else
      redirect_to "/"
      return
      #@tapedecks = []
      #@invites = []
      #@activities = []
    end
    @json = render_to_string( template: 'dashboard/index.json.jbuilder', locals: { tape: @tapedecks, invite: @invites, activities: @activities })
    respond_to do |format|
      format.html
    end
  end

  def explore
    if current_user
    @active = Tapedeck.desc(:updated_at).excludes(:private => true).excludes(:active_tape_id => nil)

    @top = Tapedeck.desc(:created_at).excludes(:private => true).excludes(:private => true).excludes(:active_tape_id => nil)

    @new = Tapedeck.desc(:created_at).excludes(:private => true).excludes(:private => true).excludes(:active_tape_id => nil)
    

    @json = render_to_string( template: 'explore/index.json.jbuilder', locals: { top: @top, active: @active, new: @new })

    respond_to do |format|
      format.html
    end
    else
      redirect_to "/"
    end
  end

  def tapes
    if current_user
      @tapedecks = Tapedeck.where({collaborator_ids: current_user.id}).desc(:created_at) #Tapedeck.where({user_id: current_user.id})
    else
      redirect_to "/"
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
      if @tapedeck.private        
        if current_user && @tapedeck.user == current_user || current_user && @tapedeck.collaborator?(current_user) || current_user && @tapedeck.invited?(current_user)
          @json = render_to_string( template: 'tapedeck/show.json.jbuilder', locals: { tapedeck: @tapedeck})
          respond_to do |format|
            format.html
          end
        else
          redirect_to "/"
        end
      else
        @json = render_to_string( template: 'tapedeck/show.json.jbuilder', locals: { tapedeck: @tapedeck})
        respond_to do |format|
          format.html
        end
      end
    end
  end

  def login
  end

  def upload
    @tapedeck = Tapedeck.find(params[:tapedeck_id])
    if current_user && (@tapedeck.collaborator?(current_user))
      newparams = coerce(params)
        @track = Track.new()
        @track.audio = Audio.new(newparams[:track])
        @track.name = @track.audio.name
        @track.audio.user = current_user
        @track.duration = @track.audio.duration
        # @track.audio = Audio.new
        @track.group = @track.id
        @track.user_id = current_user.id
        @track.color = rand(1..8) #(params[:track_length].to_i + 1)
        #puts "paraaaams #{newparams[:track][:asset].class}"
        #@track.process_asset_upload = true
        respond_to do |format|
          if @track.audio.save && @track.save 
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
      @track = Track.new()
      @track.audio = Audio.new(newparams[:track])
      @track.name = @track.audio.name
      @track.audio.user = current_user
      @track.duration = @track.audio.duration
      
      @old_track = Track.find(params[:old_track])
      @track.user_id = current_user.id
      @track.group = @old_track.group
      @track.color = @old_track.color
      @replace_id = params[:old_track]
      respond_to do |format|
        if @track.audio.save &&  @track.save
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
    if current_user.admin

      @users = User.all.limit(50)
      @user_count = User.count
      @invites = Invite.all.excludes(:email => nil).limit(50)
      @invite_count = Invite.count
      @requests = Request.all.limit(50)
      @request_count = Request.count
      @json = render_to_string( template: 'admin/users/index.json.jbuilder', locals: { users: @users, invites: @invites, requests: @requests})
      respond_to do |format|
        format.html
        # render :partial => 'admin/users/index.html.erb', :formats => [:html]
      end

    else
      redirect_to "/"
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
