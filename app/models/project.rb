class Project
  include Mongoid::Document
  include Mongoid::Timestamps

  has_and_belongs_to_many :users

  field :name, :type => String
  field :info, :type => String


end

