json.(@tapedeck, :_id, :id, :user_id, :name, :description, :active_tape_id, :genre, :genre_sub, :collaborator_ids)



json.versions @tapedeck.tapes do |json, version|
  json.partial! "tapedeck/versions.json.jbuilder", version: version
end

json.tape do |json|
  json.partial! "tapedeck/tape.json.jbuilder", tape: @tapedeck.tape
end

json.user do |json|
  json.partial! "users/user.json.jbuilder", user: @tapedeck.user
end

json.comments @tapedeck.comments.asc(:created_at) do |json,comment|
  json.partial! "tapedeck/comment.json.jbuilder", comment: comment
end

json.collaborators @tapedeck.collaborators do |json,collaborator|
  json.partial! "users/user.json.jbuilder", user: collaborator
end
