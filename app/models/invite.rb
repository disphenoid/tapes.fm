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
    date = DateTime.now
    if document.invited_user
      InviteStat.find_or_create_by(:date => date.to_date, :hour => date.hour, :type => "internal").inc(:count, 1)
    else
      InviteStat.find_or_create_by(:date => date.to_date, :hour => date.hour, :type => "external").inc(:count, 1)
    end
  end

  after_save do |document|
    
    # FIX Breakes Invite function: 
    #
    # NoMethodError (undefined method `changed?' for nil:NilClass):
    # app/models/invite.rb:25:in `block in <class:Invite>'
    # app/controllers/invites_controller.rb:28:in `create'
    # 

    # date = DateTime.now
    # if document.invited_user.changed?
    #   InviteStat.find_or_create_by(:date => date.to_date, :hour => date.hour, :type => "accepted").inc(:count, 1)
    # end
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
