# encoding: utf-8
require 'rubygems'
require 'fog'
require 'fileutils'
require 'pusher' 

Pusher.app_id = PUSHER_APP_ID.to_s 
Pusher.key = PUSHER_KEY.to_s
Pusher.secret = PUSHER_SECRET.to_s


class ConvertAudioS3
  #extend Resque::Heroku
  @queue = :convert_audio_s3
   
  def self.perform(id, sufix)

    puts "UPLOAD THE FILE NOW" 

    connection = Fog::Storage.new(
      :provider                 => 'AWS',
      :aws_secret_access_key    => "cfuOIImdhf0xSfydV2c6h2tstQKi1oY/inJ6sAJ1",
      :aws_access_key_id        => "AKIAJLUDMFIAAGNUJOIQ"
    )

    directory = connection.directories.create(
      :key    => ENV['s3_bucket_name'], # globally unique name
      :public => true
    )
 
    unless (File.directory? "#{Rails.root}/tmp/audio/")
      Dir.mkdir("#{Rails.root}/tmp/audio/", 0777)
    end
    unless (File.directory? "#{Rails.root}/tmp/audio/#{id}") 
      Dir.mkdir("#{Rails.root}/tmp/audio/#{id}", 0777)
    end

    file = directory.files.get("audio/#{id}/#{id}.#{sufix}")

    wav_path = "#{Rails.root}/tmp/audio/#{id}/#{id}.#{sufix}"
    mp3_path = "#{Rails.root}/tmp/audio/#{id}/#{id}.mp3" 

    #local_file = File.open(wav_path, "wb")
    #local_file.write(file.body)
    #local_file.close
    
    #file.body = File.open("/path/to/my/resume.html")


    #convert and upload mp3
    curl = `curl #{wav_path} #{mp3_path}` 

    curl = `curl http://#{ENV['s3_bucket_name']}.s3.amazonaws.com/audio/#{id}/#{id}.#{sufix} -o #{wav_path}`

    lameOut = `ffmpeg -b:a 128 -i #{wav_path} #{mp3_path}` 
    puts "######### convert mp3 #{lameOut}"

    mp3_file = directory.files.create(
      :key    => "audio/#{id}/#{id}.mp3",
      :body   => File.open(mp3_path),
      :public => true
    ) 
    
    model = Audio.find(id)
    model.processed = true
    model.mp3 = true
    
    if model.save() 
      Pusher[id.to_s].trigger("track", true.to_json)
    end

    # `rm -rf #{Rails.root}/tmp/audio/#{id}/`    
    FileUtils.rm_rf "#{Rails.root}/tmp/audio/#{id}/"

  end
  
end

