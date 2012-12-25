web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb

worker_mp3: env QUEUE=convert_tracks_s3 bundle exec rake resque:work
worker_wav: env QUEUE=upload_wav bundle exec rake resque:work
worker_activities: env QUEUE=push_activities bundle exec rake resque:work
worker_mails: env QUEUE=mailer bundle exec rake resque:work

#web: bundle exec rails server thin -p $PORT
#worker_upload_wav: bundle exec rake resque:work QUEUE=upload_wav
#worker_tracks: bundle exec rake resque:work QUEUE=convert_tracks
#clock: bundle exec clockwork lib/clock.rb
