json.(@collaborators) do |json, collaborator|
  json.partial! "tapedeck/collaborator.json.jbuilder", collaborator: collaborator
end


