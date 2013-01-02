
json.tapes  @tapedecks do |json,tapedeck|
  json.partial! "tapes/tapedeck.json.jbuilder", tapedeck: tapedeck, user: tapedeck.user
end
if @users
  json.users @users do |json,user|
    json.partial! "users/user.json.jbuilder", user: user
  end
end

