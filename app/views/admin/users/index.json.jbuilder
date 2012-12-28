json.request_count @request_count
json.invite_count @invite_count
json.user_count @user_count

json.users @users do |json, user|

  json.id user.id
  json.name user.name
  json.email user.email
  json.picture user.picture.m.url

end

json.invites @invites do |json, invite|

  json.id invite.id
  json.created_at invite.created_at
  json.email invite.email != "false" ? invite.email : invite.invited.name
  json.from invite.user.name if invite.user
  json.from_id invite.user_id
  json.to invite.tapedeck.name if invite.tapedeck
  json.to_id invite.tapedeck_id


end

json.requests @requests do |json, request|

  json.id request.id
  json.created_at request.created_at
  json.email request.email
  json.url request.url
  json.from request.from
  json.ip request.ip
  json.user_agent request.user_agent
  json.origin request.origin
  json.language request.language


end
