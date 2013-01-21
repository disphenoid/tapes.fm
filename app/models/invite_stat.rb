class InviteStat
  include Mongoid::Document

  field :type, :type => String
  field :user
  field :moment, type: DateTime

  index({ moment: 1, type: 1 })
  index({ moment: 1, type: 1, user: 1 }, { unique: true })
end
