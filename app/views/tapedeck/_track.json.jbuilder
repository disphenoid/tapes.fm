json.(track, :_id,:user_id ,:name, :id,:color, :version,:bpm,:group, :created_at)

json.asset track.audio.asset

json.mp3 track.audio.mp3
json.wav track.audio.wav
json.aif track.audio.aif

json.audio_id track.audio_id
json.processed track.audio.processed
json.duration track.duration

json.user(track.user, :name, :id)
json.comments track.comments.asc(:created_at) do |json,comment|
  json.partial! "tapedeck/comment.json.jbuilder", comment: comment
end
