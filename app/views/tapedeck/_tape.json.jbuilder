json.(tape, :_id, :id, :user_id, :name, :description, :tapedeck_id )
json.tracks(tape.tracks, :_id,:user_id, :id, :asset,:version,:bpm,:duration)
