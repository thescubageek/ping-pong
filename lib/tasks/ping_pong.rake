namespace :ping_pong do
  desc 'update wins/losses of players with current game stats'
  task update_records: :environment do
    if RecordUpdater.update
      puts "Success!"
    else
      puts "Fail!"
    end
  end

  desc 'update rankings and trueskill of players with current game stats'
  task update_rankings: :environment do
    if RankingUpdater.update
      puts "Success!"
    else
      puts "Fail!"
    end
  end

  desc 'update rankings and trueskill of players with current game stats'
  task update_rivalries: :environment do
    if RivalryUpdater.update
      puts "Success!"
    else
      puts "Fail!"
    end
  end
end
