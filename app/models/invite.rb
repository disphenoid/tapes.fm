class Invite
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :invited_user, class_name: "User"
  belongs_to :tapedeck
  belongs_to :request

  field :invite_hash, :type => String , :default => "0"
  field :accepted, :type => Boolean, :default => false
  field :email, :type => String

  after_create do |document|
    moment = DateTime.now
    if document.invited_user
      InviteStat.create(:moment => moment, :type => "internal", :user => document.user_id, :target => document.invited_user_id)
    else
      InviteStat.create(:moment => moment, :type => "external", :user => document.user_id)
    end
  end

  after_save do |document|
    moment = DateTime.now
    if document.invited_user_id_changed?
      InviteStat.create(:moment => moment, :type => "accepted", :user => document.invited_user_id, :initiator => document.user_id)
    end
  end

  def invited
    if self.invited_user
      return self.invited_user
    else
      user = User.new
      user.name = self.email
      user.pending = true
      user 
    end
  end
end
