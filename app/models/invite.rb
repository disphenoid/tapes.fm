class Invite
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :invited, class_name: "User"
  belongs_to :tapedeck

  field :invite_hash, :type => String
  field :accepted, :type => Boolean, :default => false

end
