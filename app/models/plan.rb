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


  def self.info plan_id 

    case plan_id
    when 4
      plan = { :name => "PRO" ,:version => 1 ,:minutes => 600 ,:multi_upload => true ,:priority_upload => true ,:private_tapes => true ,:max_samplerate => 192000 ,:price_us_month => 19.99 ,:price_eu_month => 17.99, :price_us_anual => 189.99, :price_eu_anual => 179.99 }

    when 3
      plan = { :name => "SUPREME" ,:version => 1 ,:minutes => 300 ,:multi_upload => true ,:priority_upload => true ,:private_tapes => true ,:max_samplerate => 192000 ,:price_us_month => 9.99 ,:price_eu_month => 8.99, :price_us_anual => 99.99, :price_eu_anual => 89.99 }
      
    when 2
      plan = { :name => "PLUS" ,:version => 1 ,:minutes => 100 ,:multi_upload => true ,:priority_upload => true , :private_tapes => true ,:max_samplerate => 192000 ,:price_us_month => 5.99 ,:price_eu_month => 4.99, :price_us_anual => 59.99, :price_eu_anual => 49.99 }
    else
      plan = { :name => "FREE" ,:version => 1 ,:minutes => 20 ,:multi_upload => false ,:priority_upload => false ,:private_tapes => false ,:max_samplerate => 96000 ,:price_us_month => 0 ,:price_eu_month => 0, :price_us_anual => 0, :price_eu_anual => 0 }
    end




  end





end
