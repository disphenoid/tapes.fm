CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => 'AKIAJLUDMFIAAGNUJOIQ',
    :aws_secret_access_key  => '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',
    :region                 => 'us-east-1'
  }
  config.fog_directory  = 'tapes.fm'
  config.fog_host       = 'tapes.fm.s3.amazonaws.com'
  config.fog_public     = true
  config.fog_attributes = {'Cache-Control' => 'max-age=315576000'}
end

class AvatarUploader < CarrierWave::Uploader::Base
  storage :fog
end
#Mongoid::Document::ClassMethods.send(:include, ::CarrierWave::Backgrounder::ORM::Base)
