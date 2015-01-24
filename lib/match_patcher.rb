class MatchPatcher
  def self.patch
    begin
      Match.all.each do |m|
        m.player_ids = m.get_player_ids
        m.save
      end
      return true
    rescue Exception => e
      puts e.message
    end
    false
  end
end