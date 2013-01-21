# This is basically just a bunch of counters
# associated with a date and an hour.
# This is just a global counter at this point,
# althought making it per user should be trivial
# if so desired.
class UserStat
  include Mongoid::Document

  field :type, :type => String
  field :user
  field :moment, type: DateTime

  index({ moment: 1, type: 1 })
  index({ moment: 1, type: 1, user: 1 }, { unique: true })
end
