json.(activity, :id, :_id,:type, :user_id, :tapedeck_id, :track_id, :comment_id, :track_id, :tape_id, :created_at)
json.user_name activity.user.name
json.user_picture activity.user.picture.m.url

if activity.type == "comment" && activity.comment.tapedeck
  
  json.tapedeck_name activity.comment.tapedeck.name
  json.tapedeck_id activity.comment.tapedeck_id
  json.comment_body activity.comment.body
  
end

if activity.type == "tape" && activity.tapedeck
  
  json.tapedeck_name activity.tapedeck.name
  json.tapedeck_id activity.tapedeck_id
  json.cover_s activity.tapedeck.cover.s.url
  json.version_name activity.tapedeck.tapes.last.name

  unless  activity.tapedeck.project
    json.author  activity.tapedeck.user.name
  else
    json.author  activity.tapedeck.project.name 
  end

end

if activity.type == "version" && activity.tapedeck

  
  json.tapedeck_name activity.tapedeck.name
  json.tapedeck_id activity.tapedeck_id
  json.cover_s activity.tapedeck.cover.s.url
  json.version_name activity.tape.name

  unless activity.tapedeck.project
    json.author activity.tapedeck.user.name
  else
    json.author activity.tapedeck.project.name 
  end

end
