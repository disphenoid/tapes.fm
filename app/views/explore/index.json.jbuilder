json.top_tapes top do |json, tapedeck|
  json.partial! "tapes/tapedeck.json.jbuilder", tapedeck: tapedeck 
end

json.active_tapes active do |json, tapedeck|
  json.partial! "tapes/tapedeck.json.jbuilder", tapedeck: tapedeck 
end

json.new_tapes new do |json, tapedeck|
  json.partial! "tapes/tapedeck.json.jbuilder", tapedeck: tapedeck 
end
