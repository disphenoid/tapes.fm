require 'rubygems'
require 'fog'
require 'waveinfo'
require 'fileutils'

class SoundUploader < CarrierWave::Uploader::Base
  storage :fog
  process :waveform

  def store_dir
    #"public/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    #"#{Rails.root}/tmp/uploads"
    "tracks/#{model.id}"
  end
  def extension_white_list
    %w(wav)
  end

  def waveform
    puts "##### Start Process"

    #out = ` -format "%wx%h" #{file.path}`.split(/x/)

    #generating json
    out = `#{Rails.root}/bin/wav2json #{file.path} -o #{Rails.root}/tmp/uploads/#{model.id}.json` 
    puts "######### chaka #{out}"
    puts "############### waveform1 #{file.path}" 
    jsonp(model.id)
    
    #generate mp3

    lameOut = `lame #{file.path} #{Rails.root}/tmp/uploads/#{model.id}.mp3` 
    puts "######### chaka mp3 #{lameOut}"

    #uploading .json
    connection = Fog::Storage.new(
      :provider                 => 'AWS',
      :aws_secret_access_key    => "aB+GcuPu9pUmjH1/Ab5BXKt8Bb11vqqkMGAfPYgp",
      :aws_access_key_id        => "AKIAJ4BM5OPRZICTBNLQ"
    )
    directory = connection.directories.create(
      :key    => "tapesfm", # globally unique name
      :public => true
    )

    #upload json
    json_file = directory.files.create(
      :key    => "tracks/#{model.id}/#{model.id}.json",
      :body   => File.open("#{Rails.root}/tmp/uploads/#{model.id}.json"),
      :public => true
    )
    #upload mp3
    json_file = directory.files.create(
      :key    => "tracks/#{model.id}/#{model.id}.mp3",
      :body   => File.open("#{Rails.root}/tmp/uploads/#{model.id}.mp3"),
      :public => true
    )
    #get duration
    #
    wave = WaveInfo.new("#{file.path}")
    # track = Track.find(model.id.to_s)
    # puts "########### Track id #{track.id}"
    #track.duration = wave.duration * 1000
    #track.save 
    model.duration = (wave.duration * 1000).round
    puts "########## duration = #{(wave.duration)}"
  end
  
  def jsonp fileid

    tempfile=File.open("#{Rails.root}/tmp/uploads/#{model.id}.tmp", 'w')
    f=File.new("#{Rails.root}/tmp/uploads/#{model.id}.json")
    
    f.each_with_index do |line, i|
      if i == 0
        tempfile << "waveform({\"id\":\"#{model.id}\", \"wavedata\":"
      end
      tempfile<<line
      if i == 3 
        tempfile << "});" 
      end
    end
    f.close
    tempfile.close

    FileUtils.mv("#{Rails.root}/tmp/uploads/#{model.id}.tmp", "#{Rails.root}/tmp/uploads/#{model.id}.json") 

  end

  def filename

    "#{model.id}.#{file.extension}"

  end
end
