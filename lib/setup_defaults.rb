class SetupDefaults
  def self.setup_defaults
    Player.all.destroy_all
    self.player_list.each do |player|
      p = Player.new(player)
      p.save
    end
  end

  def self.player_list
    [
      {first_name: 'Steve', last_name: 'Craig', email: 'steve.craig@getg5.com' },
      {first_name: 'Levi', last_name: 'Brown', email: 'levi.brown@getg5.com' },
      {first_name: 'Michael', last_name: 'Mitchell', email: 'michael.mitchell@getg5.com' },
      {first_name: 'Matt', last_name: 'Bishop', email: 'matt.bishop@getg5.com' },
    ]
  end
end