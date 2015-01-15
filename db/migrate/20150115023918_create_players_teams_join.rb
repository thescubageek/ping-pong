class CreatePlayersTeamsJoin < ActiveRecord::Migration
  def self.up
    create_table 'players_teams', :id => false do |t|
      t.column 'player_id', :integer
      t.column 'team_id', :integer
    end
  end

  def self.down
    drop_table 'players_teams'
  end
end
