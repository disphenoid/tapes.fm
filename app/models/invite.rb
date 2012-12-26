class Invite
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :invited_user, class_name: "User"
  belongs_to :tapedeck
  belongs_to :request

  field :invite_hash, :type => String , :default => "0"
  field :accepted, :type => Boolean, :default => false
  field :email, :type => String, :default => false

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
