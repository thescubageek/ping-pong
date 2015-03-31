class RankingUpdater
  EARLIEST_DATE = DateTime.new(2015,1,14)

  def self.update(start_match_id=nil)
    match = start_match_id ? Match.find(start_match_id) : nil
    match_date = match ? match.date : EARLIEST_DATE

    begin
      self.logger_info('Destroying all Match Ratings')
      MatchRating.where('date >= ?', match_date).destroy_all
      
      self.logger_info('Destroying all Game Ratings')
      GameRating.where('date >= ?', match_date).destroy_all
      
      self.logger_info('Creating new Ratings and Stats for Players')
      Player.all.each do |p|
        GameRating.new({player_id: p.id, date: EARLIEST_DATE}).save
        MatchRating.new({player_id: p.id, date: EARLIEST_DATE}).save
        p.update_attributes({match_wins: 0, match_losses: 0, game_wins: 0, game_losses: 0, trueskill: p.calculate_trueskill})
      end
      
      self.logger_info('Updating Player Rankings')
      Match.by_date_asc.where('date >= ?', match_date).each { |m| m.update_player_rankings }
      
      self.logger_info('Updating Player Records')
      RecordUpdater.update
      return true
    rescue Exception => e
      puts e.message
      puts e.backtrace
    end
    false
  end

  def self.logger_info(msg)
    Rails.logger.info "**INFO**: #{msg}" unless msg.blank?
  end
end