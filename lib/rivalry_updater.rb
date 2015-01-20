class RivalryUpdater
  def self.update
    begin
      Player.all.each do |p|
        p.update_rivalries
      end
      return true
    rescue Exception => e
      puts e.message
    end
    false
  end
end