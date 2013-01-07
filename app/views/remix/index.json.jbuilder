json.array!(@remixes) do |remix|
  json.partial! "tapedeck/remix.json.jbuilder", remix: remix
end

#json.tapedecks @remixes do |json,remix|
#  json.partial! "tapedeck/remix.json.jbuilder", remix: remix
#end
