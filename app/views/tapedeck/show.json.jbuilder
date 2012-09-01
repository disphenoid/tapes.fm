json.(@tapedeck, :_id, :id, :user_id, :name, :description, :active_tape_id, :genre, :genre_sub, :tape_id)

json.versions(@tapedeck.tapes, :_id, :id, :name, :created_at)

json.tape do |json|
  json.partial! "tapedeck/tape.json.jbuilder", tape: @tapedeck.tape
end
