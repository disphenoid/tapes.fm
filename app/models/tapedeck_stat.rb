class TapedeckStat
  include Mongoid::Document
  include Mongoid::Timestamps

  field :type, type: String
  field :date, type: Date
  field :hour, type: Integer, default: 0
  field :count, type: Integer, default: 0

  validates_numericality_of :count, greater_than_or_equal_to: 0
  validates_numericality_of :hour, greater_than_or_equal_to: 0
  validates_numericality_of :hour, less_than_or_equal_to: 23

  index({ date: 1, hour: 1, type: 1 }, { unique: true })
end
