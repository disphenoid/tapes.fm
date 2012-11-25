json.(user, :id, :name,:about, :created_at) 
json.picture user.picture.url
json.picture_m user.picture.m.url
json.picture_s user.picture.s.url

