json.lates_tapes @tapedecks do |json, tapedeck|
  json.partial! "tapes/tapedeck.json.jbuilder", tapedeck: tapedeck
end


json.invites @invites do |json, invite|
  json.partial! "dashboard/invite.json.jbuilder", invite: invite
end
