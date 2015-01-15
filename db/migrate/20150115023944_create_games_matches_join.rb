class CreateGamesMatchesJoin < ActiveRecord::Migration
  def self.up
    create_table 'games_matches', :id => false do |t|
      t.column 'game_id', :integer
      t.column 'match_id', :integer
    end
  end

  def self.down
    drop_table 'games_matches'
  end
end
