require 'yaml'

pusher_yaml = YAML::load(IO.read("#{Rails.root.to_s}/config/pusher.yml"))
env = Rails.env

if env
  PUSHER_APP_ID = pusher_yaml[env]["app_id"].to_s
  PUSHER_KEY = pusher_yaml[env]["key"].to_s
  PUSHER_SECRET = pusher_yaml[env]["secret"].to_s
end

