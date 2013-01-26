class Audio
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :tracks
  belongs_to :user
  
  field :file_name, :type => String
  field :name, :type => String
  field :asset, :type => String
  field :duration, :type => Float 
  field :wav, :type => Boolean, :default => false 
  field :aif, :type => Boolean, :default => false 
  field :mp3, :type => Boolean, :default => false 
  field :wavedata, :type => String
  field :processed, :type => Boolean, :default => false
  field :asset_tmp, :type => String
  field :sample_rate, :type => String
  field :channels, :type => String
  field :org_sufix, :type => String
  field :checksum, :type => String
  field :pjson, :type => Boolean, :default => true

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



