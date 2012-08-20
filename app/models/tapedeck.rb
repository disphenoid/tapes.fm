class Tapedeck
  include Mongoid::Document
  include Mongoid::Timestamps

  #embedded_in :track

  belongs_to :user
  has_many :tapes
  belongs_to :tape, :foreign_key => :active_tape_id

  field :name, :type => String
  field :description, :type => String
  field :genre, :type => String
  field :genre_sub, :type => String


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

