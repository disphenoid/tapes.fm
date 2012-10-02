class Tape
  include Mongoid::Document
  include Mongoid::Timestamps
  #default_scope order_by( [[ :created_at, :desc ]])
  default_scope desc(:created_at)
  #embedded_in :track


  belongs_to :user
  belongs_to :tapedeck
  has_many :comments
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
   field :bpm, :type => Integer
   
   #Track #1
   field :volume_1, :type => Float, :default => 100
   field :pan_1, :type => Float, :default => 0
   field :mute_1, :type => Boolean
   field :solo_1, :type => Boolean

   #Track #1
   field :volume_2, :type => Float, :default => 100
   field :pan_2, :type => Float, :default => 0
   field :mute_2, :type => Boolean, :default => false
   field :solo_2, :type => Boolean, :default => false

   #Track #3
   field :volume_3, :type => Float, :default => 100
   field :pan_3, :type => Float, :default => 0
   field :mute_3, :type => Boolean, :default => false
   field :solo_3, :type => Boolean, :default => false

   #Track #4
   field :volume_4, :type => Float, :default => 100
   field :pan_4, :type => Float, :default => 0
   field :mute_4, :type => Boolean, :default => false
   field :solo_4, :type => Boolean, :default => false

   #Track #5
   field :volume_5, :type => Float, :default => 100
   field :pan_5, :type => Float, :default => 0
   field :mute_5, :type => Boolean, :default => false
   field :solo_5, :type => Boolean, :default => false

   #Track #6
   field :volume_6, :type => Float, :default => 100
   field :pan_6, :type => Float, :default => 0
   field :mute_6, :type => Boolean, :default => false
   field :solo_6, :type => Boolean, :default => false

   #Track #7
   field :volume_7, :type => Float, :default => 100
   field :pan_7, :type => Float, :default => 0
   field :mute_7, :type => Boolean, :default => false
   field :solo_7, :type => Boolean, :default => false

   #Track #8
   field :volume_8, :type => Float, :default => 100
   field :pan_8, :type => Float, :default => 0
   field :mute_8, :type => Boolean, :default => false
   field :solo_8, :type => Boolean, :default => false




end


