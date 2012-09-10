uri = URI.parse(ENV["REDISTOGO_URL"])
#Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }




#redis_host = 'localhost:6379'

resque_yml = Rubber.root + '/config/resque.yml'
if File.exist? resque_yml
  resque_config = YAML.load_file(resque_yml)
  #redis_host = resque_config[rails_env]
end

Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
#Resque.redis = redis_host
