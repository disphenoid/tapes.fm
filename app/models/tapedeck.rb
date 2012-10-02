class Tapedeck
  include Mongoid::Document
  include Mongoid::Timestamps

  #embedded_in :track

  belongs_to :user
  belongs_to :project
  has_many :tapes
  has_many :comments
  belongs_to :tape, :foreign_key => :active_tape_id
  has_and_belongs_to_many :collaborators, inverse_of: nil, class_name: "User"

  field :name, :type => String
  field :description, :type => String
  field :genre, :type => String
  field :genre_sub, :type => String

  def collaborator?(user)

    self.collaborator_ids.include? user.id
    
  end


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

