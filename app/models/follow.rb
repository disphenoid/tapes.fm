class Follow 
  include Mongoid::Document
  include Mongoid::Timestamps
  #include Mongoid::CounterCache

  belongs_to :source, :class_name => "User"
  belongs_to :target, :class_name => "User"#, :counter_cache => true

  validates :source_id, :uniqueness => { :scope => :target_id }
  validates :source_id, :target_id, :presence => true 
  validate :validate_circular_dependency
  


    def validate_circular_dependency
      if self.source_id == self.target_id
         errors.add_to_base('A user cannot follow himself')
         # validate :method is used as callback and has to return
         # a correct value
         return false
      end
    end

end
