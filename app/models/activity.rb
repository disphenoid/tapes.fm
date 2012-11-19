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


end

