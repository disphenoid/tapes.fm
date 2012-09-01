class Tape
  include Mongoid::Document
  include Mongoid::Timestamps
  default_scope order_by( [[ :created_at, :desc ]])
  #embedded_in :track


  belongs_to :user
  belongs_to :tapedeck
  #has_many :tapedecks
  #has_many :tracks

  #belongs_to :tape, :foreign_key => :active_tape_id

  has_and_belongs_to_many :tracks, inverse_of: nil

  #embeds_many :tracks
  #belongs_to :track2, :foreign_key => 'attribute_secondary_id' 

   field :name, :type => String
   field :open, :type => Boolean, :default => true
   field :description, :type => String
   field :genre, :type => String
   field :genre_sub, :type => String




end


