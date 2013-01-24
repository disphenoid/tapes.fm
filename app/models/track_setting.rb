class TrackSetting
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :track
  belongs_to :tape

  field :volume, :type => Float, :default => 80
  field :pan, :type => Float, :default => 0
  field :mute, :type => Boolean, :default => false
  field :solo, :type => Boolean, :default => false

end
