# This is basically just a bunch of counters
# associated with a date and an hour.
# This is just a global counter at this point,
# althought making it per user should be trivial
# if so desired.
#
# i.e.
#   2013-01-01 07 "comment" 23
# means that there were 23 comments made in
# the 7th hour on that particular date.
class ActivityStat
  include Mongoid::Document
  include Mongoid::Timestamps

  field :type, :type => String
  field :date, :type => Date
  field :hour, :type => Integer, :default => 0
  field :count, :type => Integer, :default => 0

  validates_numericality_of :count, greater_than_or_equal_to: 0
  validates_numericality_of :hour, greater_than_or_equal_to: 0
  validates_numericality_of :hour, less_than_or_equal_to: 23

  index({ date: 1, hour: 1, type: 1 }, { unique: true })
end
