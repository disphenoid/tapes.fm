class Request
  include Mongoid::Document
  include Mongoid::Timestamps 

  field :email, :type => String
  field :url, :type => String
  field :from, :type => String
  field :ip, :type => String
  field :user_agent, :type => String
  field :origin, :type => String
  field :language, :type => String

end
