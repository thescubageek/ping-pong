class DropTeamsFromMatches < ActiveRecord::Migration
  def change
    remove_column :matches, :team_1_player_1_id
    remove_column :matches, :team_1_player_2_id
    remove_column :matches, :team_2_player_1_id
    remove_column :matches, :team_2_player_2_id
  end
end
