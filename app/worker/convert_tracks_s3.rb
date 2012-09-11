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
   
  def self.perform(wav_path,mp3_path,s3_path,id)

    puts "UPLOAD THE FILE NOW" 

    connection = Fog::Storage.new(
      :provider                 => 'AWS',
      :aws_secret_access_key    => "aB+GcuPu9pUmjH1/Ab5BXKt8Bb11vqqkMGAfPYgp",
      :aws_access_key_id        => "AKIAJ4BM5OPRZICTBNLQ"
    )

    directory = connection.directories.create(
      :key    => "tapesfm", # globally unique name
      :public => true
    )
   
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

