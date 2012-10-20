class Comment

  include Mongoid::Document
  include Mongoid::Timestamps
  default_scope asc(:created_at)
  scope :tape, where(:track_id => nil).excludes(:timestamp => nil).asc(:created_at)

  belongs_to :user
  belongs_to :tapedeck
  belongs_to :tape
  belongs_to :track
  
  field :body, :type => String
  field :tape_name, :type => String
  field :timestamp, :type => String, :default => nil


end
