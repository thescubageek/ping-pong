class ModifyGames < ActiveRecord::Migration
  def change
    add_column :games, :player_1_id, :integer, :null => false, :default => 0
    add_column :games, :player_2_id, :integer, :null => false, :default => 0
    add_column :games, :winner_id, :integer, :null => false, :default => 0
    add_column :games, :loser_id, :integer, :null => false, :default => 0
  end
end
