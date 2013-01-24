json.tapedecks @tapedecks do |json, tapedeck|
  if tapedeck
    json.partial! "tapes/tapedeck.json.jbuilder", tapedeck: tapedeck
  end
end
