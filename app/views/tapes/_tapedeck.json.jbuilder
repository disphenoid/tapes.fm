json.(tapedeck, :id, :_id, :name, :remixable, :commentable, :public, :genre, :project_id, :updated_at)
json.version_count = tapedeck.tapes.count

unless tapedeck.project
  json.project_name tapedeck.user.name
else
  json.project_name tapedeck.project.name 

end


json.cover tapedeck.cover.url
