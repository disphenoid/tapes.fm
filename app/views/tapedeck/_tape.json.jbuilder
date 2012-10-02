if tape
  json.(tape, :_id, :id, :user_id,:bpm, :name, :description, :tapedeck_id, :track_ids, :created_at, :volume_1 ,:mute_1 ,:solo_1 ,:pan_1 ,:volume_2 ,:mute_2 ,:solo_2 ,:pan_2 ,:volume_3 ,:mute_3 ,:solo_3 ,:pan_3 ,:volume_4 ,:mute_4 ,:solo_4 ,:pan_4 ,:volume_5 ,:mute_5 ,:solo_5 ,:pan_5 ,:volume_6 ,:mute_6 ,:solo_6 ,:pan_6 ,:volume_7 ,:mute_7 ,:solo_7 ,:pan_7 ,:volume_8 ,:mute_8 ,:solo_8 ,:pan_8)
  json.undo false 


  json.tracks(tape.tracks) do |json, track|
    json.partial! "tapedeck/track.json.jbuilder", track: track
  end

json.user_name tape.user.name
json.user_id tape.user.id
json.favorite false

json.comments(tape.comments.tape) do |json, comment|
  json.partial! "tapedeck/comment.json.jbuilder", comment: comment
end


end
