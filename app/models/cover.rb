class Cover
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :tapedecks

  mount_uploader :image, CoverUploader

end
