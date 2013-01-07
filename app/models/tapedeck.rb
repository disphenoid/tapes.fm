# require "friendly_id"
# require "friendly_id/mongoid"

class Tapedeck
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Document::Taggable

  #embedded_in :track

  belongs_to :user
  belongs_to :project
  belongs_to :cover 
  
  has_many :tapes

  has_many :comments
  has_many :invites
  belongs_to :tape, :foreign_key => :active_tape_id
  has_and_belongs_to_many :collaborators, class_name: "User"
  belongs_to :original, class_name: "Tapedeck"
  has_many :remixes, class_name: "Tapedeck", :foreign_key => :original_id

  #validates_attachment_content_type :cover, :content_type => ['image/jpeg', 'image/jpg', 'image/png', 'image/gif','image/pjpeg','image/x-png',"image/bmp","image/x-bmp"]

  field :name, :type => String
  field :description, :type => String
  field :genre, :type => String
  field :genre_sub, :type => String
  field :remixable, :type => Boolean
  field :commentable, :type => Boolean
  field :public, :type => Boolean
  field :version_count, :type => Integer
  field :remix, :type => Boolean, :default => false

  #Creative common
  field :cc, :type => Boolean, :default => true
  field :cc_by, :type => Boolean, :default => true
  field :cc_sa, :type => Boolean, :default => false
  field :cc_nc, :type => Boolean, :default => false
  field :cc_nd, :type => Boolean, :default => false

  field :cc_lock, :type => Boolean, :default => false
  
  #original cache
  field :original_name, :type => String
  field :original_author, :type => String
  field :original_user_id, :type => String
    
  #has_friendly_id :name, :use_slug => true

  # mount_uploader :cover, CoverUploader



  after_create do |doc|
    date = DateTime.now
    TapedeckStat.find_or_create_by(:date => date.to_date, :hour => date.hour, :type => "create").inc(:count, 1)
  end

  after_destroy do |doc|
    date = DateTime.now
    TapedeckStat.find_or_create_by(:date => date.to_date, :hour => date.hour, :type => "destroy").inc(:count, 1)
  end

  def all_collaborators
    pending = self.pending_collaborators.map {|d| d.invited.pending = true; d;  }
    accepted = self.collaborators
    joined = accepted + pending
  end

  def pending_collaborators
    self.invites.where({accepted: false})
  end

  def collaborator?(user)
    self.collaborator_ids.include? user.id
  end

  def to_s
    File.basename file.to_s
  end

  # def tape
  #   if self.active_tape_id
  #     self.tapes.find(self.active_tape_id)
  #   end
  # end
  # def tape=(id)
  #   if id
  #     self.active_tape_id = id
  #     self.save
  #   end
  # end
end
