class Feedback
  include Mongoid::Document
  include Mongoid::Timestamps 
  
  belongs_to :user

  field :body, :type => String 

end

