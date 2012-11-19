json.lates_tapes @tapedecks do |json, tapedeck|
  json.partial! "tapes/tapedeck.json.jbuilder", tapedeck: tapedeck
end


json.invites @invites do |json, invite|
  json.partial! "dashboard/invite.json.jbuilder", invite: invite
end


json.activities @activities do |json, activity|
  json.partial! "dashboard/activity.json.jbuilder", activity: activity
end

