json.(tapedeck, :id, :_id, :name, :remixable, :commentable, :private, :genre, :project_id,:remix, :updated_at)
json.version_count = tapedeck.tapes.count

unless tapedeck.project
  json.author tapedeck.user.name if tapedeck.user
else
  json.author tapedeck.project.name 
end

if tapedeck.remix
  json.original_author tapedeck.original_author
  json.original_name tapedeck.original_author
  json.original_id tapedeck.original_id
end

unless tapedeck.project
  #json.project_name tapedeck.user.name
else
  json.project_name tapedeck.project.name 

end

json.tags tapedeck.tags

if tapedeck.cover
  json.cover tapedeck.cover.image.url
  json.cover_m tapedeck.cover.image.m.url
  json.cover_s tapedeck.cover.image.s.url
end


#creative common

json.cc tapedeck.cc
json.cc_by tapedeck.cc_by
json.cc_sa tapedeck.cc_sa
json.cc_nc tapedeck.cc_nc
json.cc_nd tapedeck.cc_nd
