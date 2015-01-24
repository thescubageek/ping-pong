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

  desc 'patch match player_ids model'
  task patch_matches: :environment do
    if MatchPatcher.patch
      puts "Success!"
    else
      puts "Fail!"
    end
  end
end
