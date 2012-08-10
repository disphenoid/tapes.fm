class User
  include Mongoid::Document
  include Mongoid::Timestamps

  #embedded_in :track

  has_many :tapedecks
  has_many :tracks

  field :name, :type => String

end



