if tape
  json.(tape, :_id, :id, :user_id,:bpm, :name, :description, :tapedeck_id, :track_ids, :track_setting_ids, :created_at)
  json.undo false 


  json.tracks(tape.tracks) do |json, track|
    json.partial! "tapedeck/track.json.jbuilder", track: track

  end

  json.track_settings(tape.tracks) do |json, track|

      if track_setting = tape.track_settings.where({track_id: track.id}).first()
        json.track_id track_setting.track_id
        json._id track_setting._id
        json.id track_setting.id
        json.(track_setting, :volume, :pan, :mute, :solo )
      else
        json.track_id track.id
        json.volume 33
        json.pan 33
        json.mute false
        json.solo true
      end


  end

json.user_name tape.user.name


json.user_id tape.user.id
json.favorite false

json.comments(tape.comments.tape) do |json, comment|
  json.partial! "tapedeck/comment.json.jbuilder", comment: comment
end


end
