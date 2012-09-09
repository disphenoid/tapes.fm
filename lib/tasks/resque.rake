require 'resque/tasks'
task "resque:setup" => :environment do
  ENV['QUEUE'] = '*'

  # ONLY on Heroku, since they are still running PostgreSql 8 on their shared plan.
  # This block of code is not needed on PostgreSql 9, as tested on local environment.
  # Issue: My best guess is that master resque process establishes connection to db,
  # while loading rails app classes, models, etc, and that connection becomes corrupted
  # in fork()ed process (on exit?). Possible fix is to reestablish the connection the AR
  # after a Resque fork.
  #Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }

end

