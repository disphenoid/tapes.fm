class Comment

  include Mongoid::Document
  include Mongoid::Timestamps
  default_scope asc(:created_at)
  scope :tape, excludes(:timestamp => nil).asc(:created_at)

  belongs_to :user
  belongs_to :tapedeck
  belongs_to :tape
  
  field :body, :type => String
  field :timestamp, :type => String, :default => nil


end
