require 'rubygems'
require 'fog'
require 'waveinfo'
require 'fileutils'
require 'resque'
require 'digest/md5'

class ProfileUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  permissions 0777
  storage :fog
  #after :store, :add_to_process_queu
  
  process :resize_to_fill => [200, 200]
  
  version :m do
    process :resize_to_fill => [50,50]
  end
  version :s do
    process :resize_to_fill => [25,25]
  end
  # def default_url
  #   "tapes.fm.s3.amazonaws.com/covers/" + [version_name, "default.png"].compact.join('_')
  # end

  def store_dir
    #"public/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    #"#{Rails.root}/tmp/uploads"

    #"#{Rails.root}/tmp/tracks/#{model.id}"
    "users/#{model.id}"

  end


  # def move_to_cache
  #   true
  # end

  # def move_to_store
  #   true
  # end

  def filename
     "#{secure_token(10)}.#{file.extension}" if original_filename.present?
  end

  protected
  def secure_token(length=16)
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(length/2))
  end

  


end

