class Payment

  include Mongoid::Document
  include Mongoid::Timestamps 

  belongs_to :user

  
  field :plan_id, :type => Integer
  field :complete, :type => Boolean, :default => false
  field :error, :type => Boolean, :default => false
  field :params, :type => String
  field :paypal_tx, :type => String
  field :country, :type => String


end

