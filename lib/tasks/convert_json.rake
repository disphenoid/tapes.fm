require 'rake'
# require 'rest-client'
require 'rubygems'
require 'fog'
require 'waveinfo'
require 'fileutils'



task :convert_json => :environment do

  puts "start fetching audio"
  
  Audio.all.each do |audio|
    if audio.pjson
      #audio = Audio.find("50eefb1132b710331e00000c")
      id = audio.id
      json_path = "#{Rails.root}/tmp/audio/#{id}.json"
      tmp_path = "#{Rails.root}/tmp/audio/#{id}.tmp"

      curl = `curl http://assets.tapes.fm/audio/#{id}/#{id}.json -o #{json_path}`
     
      tempfile=File.open(tmp_path, 'w') 
      f=File.new(json_path)

      f.each_with_index do |line, i|
        if i == 0
          tempfile << line.gsub("waveform(", "")  #"{\"id\":\"#{model.id}\", \"wavedata\":"
          next
        end
        if i == 4 
          tempfile << "}\n" #line.gsub("});", "")  
          next
          puts line
        end    
        if i == 5 
          tempfile << "}" #line.gsub("}", "}")  
          # puts line
          next
          tempfile << ""
        end
        tempfile<<line

      end
      f.close
      tempfile.close

      FileUtils.mv(tmp_path, json_path) 


      connection = Fog::Storage.new(
        :provider                 => 'AWS',
        :aws_secret_access_key    => "cfuOIImdhf0xSfydV2c6h2tstQKi1oY/inJ6sAJ1",
        :aws_access_key_id        => "AKIAJLUDMFIAAGNUJOIQ"
      )
      directory = connection.directories.create(
        :key    => "assets.tapes.fm", 
        :public => true
      )

      json_file = directory.files.create(
        :key    => "audio/#{id}/#{id}.json",
        :body   => File.open(json_path),
        :public => true
      )

      FileUtils.rm_rf(json_path)

      audio.pjson = false

      if audio.save
        puts "done #{id}"
      end
    end
  end
end
