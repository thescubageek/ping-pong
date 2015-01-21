class CreateMatchesPlayersJoin < ActiveRecord::Migration
  def self.up
    create_table 'matches_players', :id => false do |t|
      t.column 'match_id', :integer
      t.column 'player_id', :integer
    end
  end

  def self.down
    drop_table 'matches_players'
  end
end
