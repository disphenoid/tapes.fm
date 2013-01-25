json.user do |json|
  json.id @user.id
  json.about @user.about
  json.soundcloud_name @user.soundcloud_name
  json.twitter_name @user.twitter_name
  json.facebook_name @user.facebook_name
  json.name @user.name
  json.picture @user.picture.url

  json.followers @user.followers do |json, follower|
    json.partial! "user/follower.json.jbuilder", follower: follower 
  end  

end 




if current_user
  json.is_following (current_user.following? @user)
end 

json.tapedecks @tapedecks do |json, tapedeck|
  json.partial! "tapes/tapedeck.json.jbuilder", tapedeck: tapedeck
end

