class Track
  include Mongoid::Document
  include Mongoid::Timestamps

  #embedded_in :track

  belongs_to :user
  belongs_to :tape

  field :unknown, :type => Float, :default => 0

end


