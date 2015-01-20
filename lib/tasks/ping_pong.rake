namespace :ping_pong do
  desc 'update wins/losses of players with actual game stats'
  task update_records: :environment do
    RecordUpdater.update
    puts 'Success!!'
  end

  task update_rankings: :environment do
    RankingUpdater.update
    puts 'Success!!'
  end
end
