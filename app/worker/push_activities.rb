class PushActivities

  @queue = :push_activities

  def self.perform(activity_user_id, activity_id, user_id, tapedeck_id=0)

    puts "Pushing Activity"

    to_followers(activity_user_id, activity_id, user_id) 
    
    to_collaboraters(activity_user_id, activity_id, tapedeck_id, activity_user_id) unless tapedeck_id=0 


    
  end

  def self.to_followers(activity_user_id, activity_id, user_id)

    followers = User.find(user_id).followers_list

    followers.each do |follower_id|

      unless activity_user_id == follower_id
        REDIS.zadd "activities:user:#{follower_id}", Time.now.to_i, activity_id
        trim_user_activities(follower_id) 
      end

    end
    
  end

  def self.to_collaboraters(activity_user_id, activity_id, tapedeck_id)

    collaborators = Tapedeck.find(tapedeck_id).collaborator_ids

    collaborators.each do |collaborator_id|

      unless activity_user_id == collaborator_id
        REDIS.zadd "activities:user:#{collaborator_id}", Time.now.to_i, activity_id
        trim_user_activities(collaborator_id) 
      end
    end
    
  end

  def self.trim_user_activities(id, indx=20)

    k = "activities:user:#{id}"

    if (REDIS.zcard k) >= indx
      n = indx - 1
      if (r = REDIS.zrevrange k, n, n, :with_scores => true)
        REDIS.zremrangebyscore k, "-inf", "(#{r.last}"
      end
    end

  end 


end
