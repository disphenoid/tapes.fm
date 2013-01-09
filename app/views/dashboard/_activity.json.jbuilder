json.(activity, :id, :_id,:type, :user_id, :tapedeck_id, :track_id, :comment_id, :track_id, :tape_id, :created_at)
json.user_name activity.user.name
json.user_picture activity.user.picture.m.url

if activity.type == "comment" && activity.comment.tapedeck
  
  json.tapedeck_name activity.comment.tapedeck.name if activity.comment.tapedeck
  json.tapedeck_id activity.comment.tapedeck_id
  json.comment_body activity.comment.body
  
end

if activity.type == "tape" && activity.tapedeck
  
  json.tapedeck_name activity.tapedeck.name if activity.tapedeck
  json.tapedeck_id activity.tapedeck_id
  if activity.tapedeck.cover
    json.cover_s activity.tapedeck.cover.image.s.url if activity.tapedeck
  end
  json.version_name activity.tapedeck.tapes.last.name if activity.tapedeck

  unless activity.tapedeck.project
    json.author activity.tapedeck.user.name 
  else
    json.author activity.tapedeck.project.name 
  end

end

if activity.type == "version" && activity.tapedeck

  
  json.tapedeck_name activity.tapedeck.name if activity.tapedeck

  json.tapedeck_id activity.tapedeck_id
  if activity.tapedeck.cover
    json.cover_s activity.tapedeck.cover.image.s.url if activity.tapedeck
  end
  json.version_name activity.tape.name if activity.tape


  unless activity.tapedeck.project
    json.author activity.tapedeck.user.name if activity.tapedeck

  else
    json.author activity.tapedeck.project.name if activity.tapedeck

  end

end


if activity.type == "remix" && activity.tapedeck
  
  json.tapedeck_name activity.tapedeck.name if activity.tapedeck
  json.tapedeck_id activity.tapedeck_id
  json.cover_s activity.tapedeck.cover.image.s.url if activity.tapedeck
  json.version_name activity.tapedeck.tapes.last.name if activity.tapedeck

  unless activity.tapedeck.project
    json.author activity.tapedeck.user.name 
  else
    json.author activity.tapedeck.project.name 
  end

end
