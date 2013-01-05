class Audio
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :tracks
  
  field :file_name, :type => String
  field :name, :type => String
  field :asset, :type => String
  field :duration, :type => Float 
  field :wav, :type => String 
  field :aif, :type => String 
  field :mp3, :type => String 
  field :wavedata, :type => String
  field :processed, :type => Boolean, :default => false
  field :asset_tmp, :type => String
  field :sample_rate, :type => String
  field :channels, :type => String
  field :org_sufix, :type => String

  mount_uploader :asset, AudioUploader
  # skip_callback :destroy, :after, :remove_asset!
  #store_in_background :asset, ConvertTracks
  #process_in_background :asset

  #validates :asset, presence: true
  attr_accessible :asset

  def to_s
    File.basename file.to_s
  end
end



