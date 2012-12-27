unless(ENV['SENDGRID_USERNAME'].nil?) 

  ActionMailer::Base.smtp_settings = {
    :address      => 'smtp.gmail.com',
    :port         => 587,
    :domain       => 'doo.local',
    :user_name    => 'dillinya',
    :password     =>  'the%sims9946',
    :authentication => 'plain',
    #:enable_starttls_auto => false
  }

else 
   
  ActionMailer::Base.smtp_settings = {
    :address => "smtp.sendgrid.net",
    :port => '25',
    :domain => ENV['SENDGRID_DOMAIN'],
    :authentication => :plain,
    :user_name => ENV['SENDGRID_USERNAME'],
    :password => ENV['SENDGRID_PASSWORD']
  }  

end

