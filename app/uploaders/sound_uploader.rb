require 'rubygems'
require 'fog'
require 'waveinfo'
require 'fileutils'
require 'resque'

class SoundUploader < CarrierWave::Uploader::Base
  include ::CarrierWave::Backgrounder::Delay

  #storage :fog
  process :waveform

  def move_to_cache
    true
  end

  def move_to_store
    true
  end

  def store_dir
    #"public/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    #"#{Rails.root}/tmp/uploads"

    "#{Rails.root}/tmp/tracks/#{model.id}"
  end
  def extension_white_list
    %w(wav)
  end

  def waveform
    puts "##### Start Process" 

    #generating json

    unless (File.directory? "#{Rails.root}/tmp/tracks/")
      Dir.mkdir("#{Rails.root}/tmp/tracks/", 0755)
    end
    unless (File.directory? "#{Rails.root}/tmp/tracks/#{model.id}") 
      Dir.mkdir("#{Rails.root}/tmp/tracks/#{model.id}", 0755)
    end

    if Rails.env.production?
      out = `#{Rails.root}/bin/wav2json_linux #{file.path} -o #{Rails.root}/tmp/tracks/#{model.id}/#{model.id}.json` 
    else
      out = `#{Rails.root}/bin/wav2json #{file.path} -o #{Rails.root}/tmp/tracks/#{model.id}/#{model.id}.json` 
    end

    puts "######### chaka #{out}"
    puts "############### waveform1 #{file.path}" 
    jsonp(model.id)
    
    #gets duration from wav an saves to track
    wave = WaveInfo.new("#{file.path}") 
    model.duration = (wave.duration * 1000).round
    model.sample_rate = wave.sample_rate
    model.channels = wave.channels
    model.name = File.basename(file.filename, '.*')
    puts "########## duration = #{(wave.duration)}"

    
    Resque.enqueue(ConvertTracks,"#{Rails.root}/tmp/tracks/#{model.id}/#{model.id}.wav","#{Rails.root}/tmp/tracks/#{model.id}/#{model.id}.mp3", "tracks/#{model.id}/#{model.id}.mp3",model.id)

    Resque.enqueue(UploadWav,"#{Rails.root}/tmp/tracks/#{model.id}/#{model.id}.wav", "tracks/#{model.id}/#{model.id}.wav",model.id)

    


    #generate & uploads .mp3 
    #to_mp3_and_upload(file.path,"#{Rails.root}/tmp/uploads/#{model.id}.mp3", "tracks/#{model.id}/#{model.id}.mp3",model.id)
    #uploads .wav 
    #wav_upload(file.path,"tracks/#{model.id}/#{model.id}.wav")

  end

  # def to_mp3_and_upload(wav_path,mp3_path,s3_path,id)
  #   connection = Fog::Storage.new(
  #     :provider                 => 'AWS',
  #     :aws_secret_access_key    => "aB+GcuPu9pUmjH1/Ab5BXKt8Bb11vqqkMGAfPYgp",
  #     :aws_access_key_id        => "AKIAJ4BM5OPRZICTBNLQ"
  #   )

  #   directory = connection.directories.create(
  #     :key    => "tapesfm", # globally unique name
  #     :public => true
  #   )
  #  
  #   #convert and upload mp3
  #   lameOut = `lame #{wav_path} #{mp3_path}` 
  #   puts "######### convert mp3 #{lameOut}"

  #   mp3_file = directory.files.create(
  #     :key    => s3_path,
  #     :body   => File.open(mp3_path),
  #     :public => true
  #   ) 
  # end

  # def wav_upload(wav_path,s3_path) 
  #   connection = Fog::Storage.new(
  #     :provider                 => 'AWS',
  #     :aws_secret_access_key    => "aB+GcuPu9pUmjH1/Ab5BXKt8Bb11vqqkMGAfPYgp",
  #     :aws_access_key_id        => "AKIAJ4BM5OPRZICTBNLQ"
  #   )

  #   directory = connection.directories.create(
  #     :key    => "tapesfm", # globally unique name
  #     :public => true
  #   )
  #   wav_file = directory.files.create(
  #     :key    => s3_path,
  #     :body   => File.open(wav_path),
  #     :public => true
  #   )  


  # end

  
  def jsonp fileid

    tempfile=File.open("#{Rails.root}/tmp/tracks/#{model.id}/#{model.id}.tmp", 'w')
    f=File.new("#{Rails.root}/tmp/tracks/#{model.id}/#{model.id}.json")
    
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

    FileUtils.mv("#{Rails.root}/tmp/tracks/#{model.id}/#{model.id}.tmp", "#{Rails.root}/tmp/tracks/#{model.id}/#{model.id}.json") 
    
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
      :body   => File.open("#{Rails.root}/tmp/tracks/#{model.id}/#{model.id}.json"),
      :public => true
    )

  end

  def filename

    if file
    "#{model.id}.#{file.extension}"
    end
  end
end
