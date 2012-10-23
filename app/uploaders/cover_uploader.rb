require 'rubygems'
require 'fog'
require 'waveinfo'
require 'fileutils'
require 'resque'
require 'digest/md5'

class CoverUploader < CarrierWave::Uploader::Base
  permissions 0777
  storage :fog
  #after :store, :add_to_process_queu

  def store_dir
    #"public/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    #"#{Rails.root}/tmp/uploads"

    #"#{Rails.root}/tmp/tracks/#{model.id}"
    "covers/#{model.id}"

  end


  def move_to_cache
    true
  end

  def move_to_store
    true
  end


  def filename
    if original_filename
    
    file_name = model.id.to_s + Time.now.to_s
    
    "#{Digest::MD5.hexdigest(file_name)}.#{file.extension}"
    end
  end

  


end
