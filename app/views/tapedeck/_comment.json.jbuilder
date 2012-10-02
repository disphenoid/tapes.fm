json.(comment, :body, :_id, :id,:tape_id, :tapedeck,:timestamp, :created_at)
json.user_name comment.user.name
if comment.tape
  json.tape_name comment.tape.name
end
json.user_id comment.user.id

