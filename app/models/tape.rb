class Tape
  include Mongoid::Document
  include Mongoid::Timestamps

  #embedded_in :track

  belongs_to :user
  belongs_to :tapedeck
  has_many :tapedecks
  has_many :tracks

  field :name, :type => String
  field :description, :type => String
  field :genre, :type => String
  field :genre_sub, :type => String


end


