require 'rubygems'
require 'fog'
require 'fileutils'

class UploadWav
  #extend Resque::Heroku
  @queue = :upload_wav
   
  def self.perform(wav_path,s3_path,id)
    
    puts "uploading from #{wav_path} to #{s3_path}"
    
    connection = Fog::Storage.new(
      :provider                 => 'AWS',
      :aws_secret_access_key    => "aB+GcuPu9pUmjH1/Ab5BXKt8Bb11vqqkMGAfPYgp",
      :aws_access_key_id        => "AKIAJ4BM5OPRZICTBNLQ"
    )

    directory = connection.directories.create(
      :key    => ENV['s3_bucket_name'], # globally unique name
      :public => true
    )
    wav_file = directory.files.create(
      :key    => s3_path,
      :body   => File.open(wav_path),
      :public => true
    )  

  end
end
