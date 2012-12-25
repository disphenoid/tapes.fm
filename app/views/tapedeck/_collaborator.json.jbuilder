json.(collaborator,  :_id, :id, :created_at)

if collaborator.respond_to?(:name)
  json.name collaborator.name
else
  json.name collaborator.invited.name
end

if collaborator.respond_to?(:picture)
  json.user_picture collaborator.picture.m.url
else
  json.user_picture collaborator.invited.picture.m.url
end

if collaborator.respond_to?(:pending)
  json.pending false
else
  json.pending true
end

if collaborator.respond_to?(:accepted)
  json.accepted collaborator.accepted
else
  json.accepted true
end




