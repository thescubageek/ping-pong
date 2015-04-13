class RivalryUpdater
  def self.update(players=nil)
    begin
      players ||= Player.no_zeros
      players.each do |p|
        p.update_player_rivalries
      end
      return true
    rescue Exception => e
      puts e.message
    end
    false
  end
end