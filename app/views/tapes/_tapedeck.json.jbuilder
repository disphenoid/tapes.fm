json.(tapedeck, :id, :_id, :name, :remixable, :commentable, :public, :genre, :project_id, :updated_at)
json.version_count = tapedeck.tapes.count

unless tapedeck.project
  json.author tapedeck.user.name if tapedeck.user
else
  json.author tapedeck.project.name 
end


unless tapedeck.project
  #json.project_name tapedeck.user.name
else
  json.project_name tapedeck.project.name 

end

json.tags tapedeck.tags


json.cover tapedeck.cover.url
json.cover_m tapedeck.cover.m.url
json.cover_s tapedeck.cover.s.url
