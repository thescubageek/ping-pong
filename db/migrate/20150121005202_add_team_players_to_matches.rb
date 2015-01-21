class AddTeamPlayersToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :team_1_player_1_id, :integer, :null => false, :default => 0
    add_column :matches, :team_1_player_2_id, :integer, :null => true
    add_column :matches, :team_2_player_1_id, :integer, :null => false, :default => 0
    add_column :matches, :team_2_player_2_id, :integer, :null => true
  end
end
