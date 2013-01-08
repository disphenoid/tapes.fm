class Tape
  include Mongoid::Document
  include Mongoid::Timestamps
  #default_scope order_by( [[ :created_at, :desc ]])
  default_scope desc(:created_at)
  #embedded_in :track


  belongs_to :user
  belongs_to :tapedeck
  has_many :comments
  #has_many :tracks

  #belongs_to :tape, :foreign_key => :active_tape_id

  has_and_belongs_to_many :tracks, inverse_of: nil
  has_many :track_settings

  #embeds_many :tracks
  #belongs_to :track2, :foreign_key => 'attribute_secondary_id'

  field :name, :type => String
  field :open, :type => Boolean, :default => true
  field :description, :type => String
  field :genre, :type => String
  field :genre_sub, :type => String
  field :bpm, :type => Float, :default => 120

  after_create do |doc|
    date = DateTime.now
    TapeStat.find_or_create_by(:date => date.to_date, :hour => date.hour, :type => "create").inc(:count, 1)
    if doc.tapedeck
      doc.tapedeck.inc(:version_count, 1)
    end
  end

  after_destroy do |doc|
    date = DateTime.now
    TapeStat.find_or_create_by(:date => date.to_date, :hour => date.hour, :type => "destroy").inc(:count, 1)
    doc.tapedeck.inc(:version_count, -1) unless doc.tapedeck.blank?
  end

  def track_setting_volume(track_id, value)
    setting = TrackSetting.find_or_initialize_by({track_id: track_id, tape_id: self.id})
    setting.volume = value
    self.track_settings.push(setting)
    self.save
  end

  def track_setting_pan(track_id, value)
    setting = TrackSetting.find_or_initialize_by({track_id: track_id, tape_id: self.id})
    setting.pan = value
    self.track_settings.push(setting)
    self.save
  end

  def track_setting_mute(track_id, value)
    setting = TrackSetting.find_or_initialize_by({track_id: track_id, tape_id: self.id})
    setting.mute = value
    self.track_settings.push(setting)
    self.save
  end

  def track_setting_solo(track_id, value)
    setting = TrackSetting.find_or_initialize_by({track_id: track_id, tape_id: self.id})
    setting.solo = value
    self.track_settings.push(setting)
    self.save
  end
end
