require 'resque'

class User
  include Mongoid::Document
  include Mongoid::Timestamps 

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :token_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              :type => String
  field :encrypted_password, :type => String

  validates_presence_of :email
  validates_presence_of :encrypted_password
  validates_uniqueness_of :name, :case_sensitive => false
  validates_uniqueness_of :email, :case_sensitive => false

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time
 
  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String
  field :pending,    :type => Boolean
  field :invited_id,    :type => String

  field :total_uploadtime,    :type => Integer, :default => 0
  field :current_uploadtime,    :type => Integer, :default => 0

  field :admin, :type => Boolean, :default => false
  field :super, :type => Boolean, :default => false

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  field :authentication_token, :type => String
  before_save :ensure_authentication_token
  
  index({ email: 1 }, { unique: true, name: "email_index" })
  field :name
  field :nickname
  #validates_presence_of :name
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :about, :twitter_name, :soundcloud_name, :facebook_name

  has_many :tapedecks, :dependent => :destroy
  has_many :tracks
  has_and_belongs_to_many :projects

  field :name, :type => String
  field :plan_id, :type => Integer
  field :about, :type => String

  field :twitter_name, :type => String
  field :soundcloud_name, :type => String
  field :facebook_name, :type => String


  mount_uploader :picture, ProfileUploader
  

  def add_time(mil)
    self.total_uploadtime += mil.to_i
    self.current_uploadtime += mil.to_i
    self.save

    self.current_uploadtime 

  end

  def upload_time
    self.current_uploadtime
  end
  def upload_min
    d = (self.current_uploadtime.to_f / 1000)
    m = (d / 60).ceil

  end


  def stream( p_page=1)
     
      p = redis_pagination(p_page)

      stream = []
      stream_array = REDIS.zrevrange("activities:user:#{self.id}",p[:start],p[:end])

      stream_array.each do |activity_id| 
        activity = Activity.find(activity_id) rescue nil 
        if activity
          stream <<  activity
        end
      end

      stream

  end


  def stream_list(count=0)

    if count == 0
      REDIS.zrevrange "activities:user:#{self.id}", 0, -1
    else
      REDIS.zrevrange "activities:user:#{self.id}", 0, -1
    end

  end

  def push_activity(type,object)

    case type
    
      when "comment"
        
        activity = Activity.find_or_create_by({:type => "comment", :user_id => self.id, :comment_id => object.id, :tapedeck_id => object.tapedeck_id} )
        Resque.enqueue(PushActivities,self.id, activity.id, self.id, object.tapedeck_id) if activity
      
      when "follow"

        activity = Activity.find_or_create_by({:type => "follow", :user_id => self.id} ) 
        REDIS.zadd "activities:user:#{object.id}", Time.now.to_i, activity.id
        #activity = Activity.create_f!({:type => "comment", :user_id => self.id, :comment_id => object.id} )

      when "tape"
          activity = Activity.find_or_create_by({:type => "tape", :user_id => self.id, :tapedeck_id => object.tapedeck_id} )
          Resque.enqueue(PushActivities,self.id, activity.id, self.id, object.tapedeck_id) if activity

      when "version"
          activity = Activity.find_or_create_by({:type => "version", :user_id => self.id,:tape_id => object.id, :tapedeck_id => object.tapedeck_id} )
          Resque.enqueue(PushActivities,self.id, activity.id, self.id, object.tapedeck_id) if activity

    end

    
  end

  #follower feature (redis)

  # follow a user




  def follow!(user)
    REDIS.multi do
      REDIS.sadd(self.follow_key(:following), user.id)
      REDIS.sadd(user.follow_key(:followers), self.id)
    end
  end
  
  # unfollow a user
  def unfollow!(user)
    REDIS.multi do
      REDIS.srem(self.follow_key(:following), user.id)
      REDIS.srem(user.follow_key(:followers), self.id)
    end
  end

  # users that self follows
  def followers_list
    user_ids = REDIS.smembers(self.follow_key(:followers))
  end
  def followers
    user_ids = REDIS.smembers(self.follow_key(:followers))
    User.where(:id => user_ids)
  end

  # users that follow self
  def following_list
    user_ids = REDIS.smembers(self.follow_key(:following))
  end
  def following
    user_ids = REDIS.smembers(self.follow_key(:following))
    User.where(:id => user_ids)
  end

  # users who follow and are being followed by self
  def friends
    user_ids = REDIS.sinter(self.follow_key(:following), self.follow_key(:followers))
    User.where(:id => user_ids)
  end

  # does the user follow self
  def followed_exist?
    REDIS.exists(self.follow_key(:followers))
  end
  
  # does self follow user
  def following?(user)
    REDIS.sismember(self.follow_key(:following), user.id)
  end

 # does self follow user
  def following?(user)
    REDIS.sismember(self.follow_key(:following), user.id)
  end



  # number of followers
  def followers_count
    REDIS.scard(self.follow_key(:followers))
  end

  # number of users being followed
  def following_count
    REDIS.scard(self.follow_key(:following))
  end
  
  # helper method to generate redis keys
  def follow_key(str)
    "user:#{self.id}:#{str}"
  end

  #redis keys


  def self.redis_key(item_id)
    "user:#{item_id}"
  end
  def redis_key(item_id)
    "user:#{item_id}"
  end



  def redis_pagination(p_page)

      chunk_size = 10
      page = p_page.to_i
      
      if page == 1
        range_begin = 0
        range_end = chunk_size 
      else

        range_begin = (chunk_size * page) 
        range_end = (chunk_size * page) +chunk_size -1
      end
      
      return {:start => range_begin, :end => range_end} 

  end

  
  def plan

    case self.plan_id
    when 2
      plan = { :name => "PLUS" ,:version => 1 ,:minutes => 300 ,:multi_upload => false ,:priority_upload => true ,:private_tapes => false ,:max_samplerate => 192000 ,:price_us => 7.90 ,:price_eu => 9.90 }
    else
      plan = { :name => "BASIC" ,:version => 1 ,:minutes => 100 ,:multi_upload => false ,:priority_upload => false ,:private_tapes => false ,:max_samplerate => 96000 ,:price_us => 0 ,:price_eu => 0 }
    end

    
  end



end
