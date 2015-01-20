class RankingUpdater
  def self.update
    begin
      PlayerRating.destroy_all
      Player.all.each do |p|
        rating = PlayerRating.new({player_id: p.id, date: DateTime.new(2015,1,14)})
        rating.save
        p.update_attributes({match_wins: 0, match_losses: 0, game_wins: 0, game_losses: 0})
      end
      mc = MatchController.new
      Match.by_date_asc.each do |m|
        m.update_player_rankings
      end
      RecordUpdater.update
      return true
    rescue Exception => e
      puts e.message
    end
    false
  end
end