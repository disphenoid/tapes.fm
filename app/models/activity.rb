class Activity
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :tapedeck
  belongs_to :comment
  belongs_to :tape
  belongs_to :track

  # field :body, :type => String
  field :type, :type => String

  after_create do |document|
    date = DateTime.now
    ActivityStat.find_or_create_by(:date => date.to_date, :hour => date.hour, :type => document.type).inc(:count, 1)
  end
end
