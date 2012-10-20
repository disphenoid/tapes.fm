json.(track, :_id,:user_id ,:name, :id, :asset,:color, :version,:bpm,:duration,:processed,:group, :created_at)
json.user(track.user, :name, :id)
json.comments track.comments.asc(:created_at) do |json,comment|
  json.partial! "tapedeck/comment.json.jbuilder", comment: comment
end
