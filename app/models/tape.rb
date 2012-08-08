class Tape < ActiveRecord::Base
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, type => String
  field :bpm, type = Integer


  attr_accessible :bpm, :name


end
