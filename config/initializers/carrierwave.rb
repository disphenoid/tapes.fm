CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => 'AKIAJ4BM5OPRZICTBNLQ',
    :aws_secret_access_key  => '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',
    :region                 => 'us-east-1'
  }
  config.fog_directory  = 'tapesfm'
  config.fog_host       = 'tapesfm.s3.amazonaws.com'
  config.fog_public     = true
  config.fog_attributes = {'Cache-Control' => 'max-age=315576000'}
end

class AvatarUploader < CarrierWave::Uploader::Base
  storage :fog
end
