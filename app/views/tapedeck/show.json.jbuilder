json.(@tapedeck, :_id, :id, :user_id, :name, :description, :active_tape_id, :genre, :genre_sub, :remix, :collaborator_ids, :project_id, :private, :commentable, :remixable, :remix)
unless tapedeck.project
  json.author tapedeck.user.name
else
  json.author tapedeck.project.name 
end
if @tapedeck.project
  json.project_name @tapedeck.project.name 
end

if @tapedeck.remix
  json.original_author @tapedeck.original_author
  json.original_name @tapedeck.original_name
  json.original_id @tapedeck.original_id
end

json.remixes @tapedeck.remixes

if @tapedeck.cover
  json.cover @tapedeck.cover.image.url
  json.cover_m @tapedeck.cover.image.m.url
end

json.versions @tapedeck.tapes.desc(:created_at) do |json, version|
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

if current_user && @tapedeck.collaborator?(current_user)
  json.collaborators @tapedeck.all_collaborators do |json,collaborator|
    json.partial! "tapedeck/collaborator.json.jbuilder", collaborator: collaborator 
  end
else
  json.collaborators @tapedeck.collaborators do |json,collaborator|
    json.partial! "tapedeck/collaborator.json.jbuilder", collaborator: collaborator 
  end
end

json.tags @tapedeck.tags

#creative common

json.cc tapedeck.cc
json.cc_by tapedeck.cc_by
json.cc_sa tapedeck.cc_sa
json.cc_nc tapedeck.cc_nc
json.cc_nd tapedeck.cc_nd

