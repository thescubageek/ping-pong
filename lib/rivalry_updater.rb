class RivalryUpdater
  def self.update
    begin
      Player.no_zeros.each do |p|
        p.update_player_rivalries
      end
      return true
    rescue Exception => e
      puts e.message
    end
    false
  end
end