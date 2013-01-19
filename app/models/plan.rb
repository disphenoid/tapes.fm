class Plan
  include Mongoid::Document
  include Mongoid::Timestamps 



  field :name, :type => String
  field :version, :type => Integer
  field :minutes, :type => Integer

  field :multi_upload, :type => Boolean
  field :priority_upload, :type => Boolean
  field :private_tapes, :type => Boolean
  field :max_samplerate, :type => Integer

  field :price_us_month, :type => Float
  field :price_eu_month, :type => Float

  field :price_us_anual, :type => Float
  field :price_eu_anual, :type => Float  

end
