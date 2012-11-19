json.user(@user,:id, :name)
if current_user
  json.is_following (current_user.following? @user)
end


json.tapedecks @tapedecks do |json, tapedeck|
  json.partial! "tapes/tapedeck.json.jbuilder", tapedeck: tapedeck
end

