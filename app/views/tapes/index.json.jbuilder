json.tapedecks @tapedecks do |json, tapedeck|
  json.partial! "tapes/tapedeck.json.jbuilder", tapedeck: tapedeck
end
