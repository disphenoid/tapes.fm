json.user do |json|
  json.id @user.id
  json.about @user.about
  json.name @user.name
  json.picture @user.picture.url

end


if current_user
  json.is_following (current_user.following? @user)
end



json.tapedecks @tapedecks do |json, tapedeck|
  json.partial! "tapes/tapedeck.json.jbuilder", tapedeck: tapedeck
end

