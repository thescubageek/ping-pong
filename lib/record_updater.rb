class RecordUpdater
  def self.update(players=nil)
    begin
      players ||= Player.all
      players.each do |p|
        mwins = p.calculate_match_wins
        mlosses = p.calculate_match_losses
        gwins = p.calculate_game_wins
        glosses = p.calculate_game_losses
        p.update_attributes({match_wins: mwins, match_losses: mlosses, game_wins: gwins, game_losses: glosses})
      end
      return true
    rescue Exception => e
      puts e.message
    end
    false
  end
end