require 'rubygems'
require 'fog'
require 'waveinfo'
require 'fileutils'
require 'resque'

class AudioUploader < CarrierWave::Uploader::Base
  #include ::CarrierWave::Backgrounder::Delay

  permissions 0777
  storage :fog
  process :waveform
  before :store, :remember_cache_id
  after :store, :add_to_process_queu



  def store_dir

    "audio/#{model.id}"

  end
  def extension_white_list
    %w(aiff aif wav)
  end

  def remember_cache_id(new_file)
    @cache_id_was = cache_id
  end

  def add_to_process_queu(argue)
    #Resque.enqueue(ConvertAudioS3,model.id, model.org_sufix)
    ConvertAudioS3.enqueue(model, model.user_id)

    tmp_path =  "#{Rails.root}/tmp/audio/#{model.id}/"

    # `rm -rf #{tmp_path}`
    FileUtils.rm_rf tmp_path

    if @cache_id_was.present? && @cache_id_was =~ /\A[\d]{8}\-[\d]{4}\-[\d]+\-[\d]{4}\z/
      FileUtils.rm_rf(File.join(cache_dir, @cache_id_was))
    end


  end

  def waveform
    puts "##### Start Process" 
    #make tmp folder 

    unless (File.directory? "#{Rails.root}/tmp/audio/")
      Dir.mkdir("#{Rails.root}/tmp/audio/", 0777)
    end
    unless (File.directory? "#{Rails.root}/tmp/audio/#{model.id}") 
      Dir.mkdir("#{Rails.root}/tmp/audio/#{model.id}", 0777)
    end
    
    #cut silence
    tmp_path =  "#{Rails.root}/tmp/audio/#{model.id}/"


    `sox #{file.path} #{tmp_path+model.id.to_s+"-r"}.#{file.extension} reverse;` 
    `sox #{tmp_path+model.id.to_s+"-r"}.#{file.extension} #{tmp_path+model.id.to_s+"-rc"}.#{file.extension} silence 1 00:00:00 -96d;` 
    `sox #{tmp_path+model.id.to_s+"-rc"}.#{file.extension} #{file.path} reverse;`

    #remove files
    # `rm #{tmp_path+model.id.to_s+"-r"}.#{file.extension}`
    # `rm #{tmp_path+model.id.to_s+"-rc"}.#{file.extension}`
    # `rm #{tmp_path+model.id.to_s+"-r"}.#{file.extension}`



    `#{Rails.root}/bin/wav2json_linux #{file.path} -o #{Rails.root}/tmp/audio/#{model.id}/#{model.id}.json`


    #generating json


    if Rails.env.production?
      out = `#{Rails.root}/bin/wav2json_linux #{file.path} -o #{Rails.root}/tmp/audio/#{model.id}/#{model.id}.json` 
    else
      out = `#{Rails.root}/bin/wav2json #{file.path} -o #{Rails.root}/tmp/audio/#{model.id}/#{model.id}.json` 
    end

    puts "######### chaka #{out}"
    puts "############### waveform1 #{file.path}" 
    


    if file.extension
      model.org_sufix = file.extension
    end

    case file.extension
      when /^#{"wav"}$/i
        model.wav = true
      when /^#{"aif"}$/i
        model.aif = true
      when /^#{"aiff"}$/i 
        model.aif = true
    end


    #remove_silence(model.id)
    jsonp(model.id)
    

    duration = `soxi -D #{file.path}`
    model.duration = (duration.gsub("\n","").to_f * 1000).round

    sample_rate = `soxi -r #{file.path}`
    model.sample_rate = sample_rate.gsub("\n","").to_i

    channels = `soxi -c #{file.path}`
    model.channels = channels.gsub("\n","").to_i    


    model.name = File.basename(file.filename, '.*')
    model.file_name = File.basename(file.filename, '.*')

    # FileUtils.rm_rf("#{Rails.root}/tmp/audio/#{model.id}/")


  end


  def jsonp fileid

    tempfile=File.open("#{Rails.root}/tmp/audio/#{model.id}/#{model.id}.tmp", 'w')
    f=File.new("#{Rails.root}/tmp/audio/#{model.id}/#{model.id}.json")
    
    f.each_with_index do |line, i|
      if i == 0
        tempfile << "waveform({\"id\":\"#{model.id}\", \"wavedata\":"
      end
      tempfile<<line
      if Rails.env.production?

        if i == 4 
          tempfile << "});" 
        end
      else
        if i == 3 
          tempfile << "});" 
        end
      end
    end
    f.close
    tempfile.close

    FileUtils.mv("#{Rails.root}/tmp/audio/#{model.id}/#{model.id}.tmp", "#{Rails.root}/tmp/audio/#{model.id}/#{model.id}.json") 
    
    #uploading .json
    connection = Fog::Storage.new(
      :provider                 => 'AWS',
      :aws_secret_access_key    => "cfuOIImdhf0xSfydV2c6h2tstQKi1oY/inJ6sAJ1",
      :aws_access_key_id        => "AKIAJLUDMFIAAGNUJOIQ"
    )
    directory = connection.directories.create(
      :key    => ENV['s3_bucket_name'], # globally unique name
      :public => true
    )

    #upload json
    json_file = directory.files.create(
      :key    => "audio/#{model.id}/#{model.id}.json",
      :body   => File.open("#{Rails.root}/tmp/audio/#{model.id}/#{model.id}.json"),
      :public => true
    )
    
    
    #directory.destroy

  end

  def filename
    if original_filename
    "#{model.id}.#{file.extension}"
    end
  end
end
