require 'rubygems'
require 'fog'
require 'fileutils'
require 'pusher' 

Pusher.app_id = PUSHER_APP_ID.to_s 
Pusher.key = PUSHER_KEY.to_s
Pusher.secret = PUSHER_SECRET.to_s


class ConvertTracksS3
  #extend Resque::Heroku
  @queue = :convert_tracks_s3
   
  def self.perform(id)

    puts "UPLOAD THE FILE NOW" 

    connection = Fog::Storage.new(
      :provider                 => 'AWS',
      :aws_secret_access_key    => "cfuOIImdhf0xSfydV2c6h2tstQKi1oY/inJ6sAJ1",
      :aws_access_key_id        => "AKIAJLUDMFIAAGNUJOIQ"
    )

    directory = connection.directories.create(
      :key    => "tapes.fm", # globally unique name
      :public => true
    )
 
    file = directory.files.get("tracks/#{id}/#{id}.wav")

    wav_path = "#{Rails.root}/tmp/tracks/#{id}/#{id}.wav"
    mp3_path = "#{Rails.root}/tmp/tracks/#{id}/#{id}.mp3"


    local_file = File.open(wav_path, "w")
    local_file.write(file.body)
    local_file.close
    
    #file.body = File.open("/path/to/my/resume.html")


    #convert and upload mp3
    lameOut = `lame #{wav_path} #{mp3_path}` 
    puts "######### convert mp3 #{lameOut}"

    mp3_file = directory.files.create(
      :key    => s3_path,
      :body   => File.open(mp3_path),
      :public => true
    ) 
    
    model = Track.find(id)
    model.processed = true
    
    if model.save() 
      Pusher[model.id.to_s].trigger("track", true.to_json)
    end

  end
  
end

