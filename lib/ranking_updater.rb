class RankingUpdater
  def self.update(match_id=0)
    if match_id == 0
      begin
        PlayerRating.destroy_all
        Player.all.each do |p|
          rating = PlayerRating.new({player_id: p.id, date: DateTime.new(2015,1,14)})
          rating.save
          p.update_attributes({match_wins: 0, match_losses: 0, game_wins: 0, game_losses: 0})
        end
        Match.by_date_asc.each { |m| m.update_player_rankings }
        RecordUpdater.update
        return true
      rescue Exception => e
        puts e.message
      end
    else
      match = Match.find(match_id)
      if match
        begin
          PlayerRating.where('date >= ?', match.date).destroy_all
          Match.where('id >= ?', match_id).by_date_asc.each { |m| m.update_player_rankings }
          Player.all.each { |p| p.update_attributes({match_wins: 0, match_losses: 0, game_wins: 0, game_losses: 0}) }
          RecordUpdater.update
          return true
        rescue Exception => e
          puts e.message
        end
      end
    end
    false
  end
end