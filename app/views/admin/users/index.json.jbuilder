json.users @users do |json, user|

  json.id user.id
  json.name user.name
  json.email user.email
  json.picture user.picture.m.url

end


json.requests @requests do |json, request|

  json.created_at request.created_at
  json.email request.email
  json.url request.url
  json.from request.from
  json.ip request.ip
  json.user_agent request.user_agent
  json.origin request.origin
  json.language request.language


end
