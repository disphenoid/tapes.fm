json.(@tracks) do |json, track|
  json.partial! "tapedeck/track.json.jbuilder", track: track

end
