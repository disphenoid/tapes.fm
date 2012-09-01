json.(versions) do |json, version|
  json.(version, :name, :_id, :id, :created_at)
end
