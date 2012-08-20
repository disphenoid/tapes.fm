
class Track
  include Mongoid::Document
  include Mongoid::Timestamps

  #embedded_in :track

  belongs_to :user
  #belongs_to :tape
  #belongs_to :track 
  
  field :name, :type => String
  field :version, :type => Integer 
  field :instrument, :type => String
  field :asset, :type => String
  field :bpm, :type => Float, :default => 120
  field :group, :type => String 
  field :duration, :type => String 
  field :wavedata, :type => String

  mount_uploader :asset, SoundUploader

  validates :asset, presence: true
  attr_accessible :asset

  def to_s
    File.basename file.to_s
  end
end


