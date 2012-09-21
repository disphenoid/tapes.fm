json.track do |json| 
  json.partial! "tapedeck/track.json.jbuilder", track: @track
end
json.replace_track_id @replace_id

