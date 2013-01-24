json.(@tapedeck, :_id, :id, :user_id, :name, :description, :active_tape_id, :genre, :genre_sub, :remix, :collaborator_ids, :project_id, :private, :commentable, :remixable, :remix, :cc, :cc_by, :cc_sa, :cc_nc, :cc_nd)
unless @tapedeck.project
  json.author @tapedeck.user.name
else
  json.author @tapedeck.project.name 
end
