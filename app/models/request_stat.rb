class RequestStat
  include Mongoid::Document

  field :type, :type => String
  field :from
  field :moment, type: DateTime

  index({ moment: 1, type: 1 })
  index({ moment: 1, type: 1, from: 1 }, { unique: true })
end
