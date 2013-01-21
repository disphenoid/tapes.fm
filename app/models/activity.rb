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

  #after_create do |document|
    #moment = DateTime.now
    #ActivityStat.create(:moment => moment, :type => document.type, :user => document.user_id)
  #end
end
