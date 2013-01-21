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

  after_create do |document|
    moment = DateTime.now
    RequestStat.create(:moment => moment, :type => "create", :from => document.from)
  end

  after_destroy do |document|
    moment = DateTime.now
    RequestStat.create(:moment => moment, :type => "destroy", :from => document.from)
  end
end
