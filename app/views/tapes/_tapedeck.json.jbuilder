json.(tapedeck, :id, :_id, :name, :remixable, :commentable, :public, :genre, :project_id)
unless tapedeck.project
  json.project_name tapedeck.user.name
else
  json.project_name tapedeck.project.name


end


json.cover tapedeck.cover.url
