class Invite
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :inviter, class_name: "User"
  belongs_to :tapedeck

end
