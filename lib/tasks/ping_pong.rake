namespace :ping_pong do
  desc 'update wins/losses of players with actual game stats'
  task update: :environment do
    RecordUpdater.update
    puts 'Success!!'
  end
end
