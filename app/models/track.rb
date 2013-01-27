class Track
  include Mongoid::Document
  include Mongoid::Timestamps
  default_scope order_by( [[ :created_at, :desc ]])
  #embedded_in :track

  belongs_to :user
  belongs_to :audio
  has_many :comments
  has_and_belongs_to_many :track_settings, inverse_of: nil
  #belongs_to :tape
  #belongs_to :track 
  
  field :name, :type => String
  field :file_name, :type => String
  field :version, :type => Integer 
  field :instrument, :type => String
  field :asset, :type => String
  field :bpm, :type => Float, :default => 120
  field :group, :type => String 
  field :duration, :type => Float 
  field :wav, :type => String 
  field :aif, :type => String 
  field :mp3, :type => String 
  field :wavedata, :type => String
  field :color, :type => Integer, :default => 1
  field :processed, :type => Boolean, :default => false
  field :asset_tmp, :type => String
  field :sample_rate, :type => String
  field :channels, :type => String
  field :org_sufix, :type => String
  field :copy, :type => String, :default => false

  mount_uploader :asset, SoundUploader
  skip_callback :destroy, :after, :remove_asset!
  #store_in_background :asset, ConvertTracks
  #process_in_background :asset
  # field :original_name, :type => String
  # field :original_author, :type => String
  field :original_user_id, :type => String

  #validates :asset, presence: true
  attr_accessible :asset

  after_create do |document|
    moment = DateTime.now
    TrackStat.create(:moment => moment, :type => "create", :user => document.user_id)
  end

  after_destroy do |document|
    moment = DateTime.now
    TrackStat.create(:moment => moment, :type => "destroy", :user => document.user_id)
  end

  def to_s
    File.basename file.to_s
  end
end
