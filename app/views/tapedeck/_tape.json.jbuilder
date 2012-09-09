if tape
  json.(tape, :_id, :id, :user_id, :name, :description, :tapedeck_id, :track_ids, :created_at )
  json.tracks(tape.tracks, :_id,:user_id,:name, :id, :asset,:color,:version,:bpm,:duration, :processed, :created_at)
  
  # json.tape.tracks do |json, track|
  #   json.partial! "tapedeck/track.json.jbuilder", track: track
  # end

end
