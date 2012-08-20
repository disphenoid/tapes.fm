class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :user
  belongs_to :tapedeck
  belongs_to :tape
  belongs_to :track

end
