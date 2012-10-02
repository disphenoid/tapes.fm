json.(@comments) do |json,comment|
  json.partial! "tapedeck/comment.json.jbuilder", comment: comment
end
