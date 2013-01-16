json.(invite, :id, :_id, :tapedeck_id)

json.name invite.tapedeck.name 

unless invite.tapedeck.project
  json.project_name invite.tapedeck.user.name
else
  json.project_name invite.tapedeck.project.name 
end

if invite.tapedeck.cover
  json.cover invite.tapedeck.cover.url
end
