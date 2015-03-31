class ModifyMatches < ActiveRecord::Migration
  def change
    add_column :matches, :player_1_id, :integer, :null => false, :default => 0
    add_column :matches, :player_2_id, :integer, :null => false, :default => 0
    add_column :matches, :winner_id, :integer, :null => false, :default => 0
    add_column :matches, :loser_id, :integer, :null => false, :default => 0
    add_column :matches, :score_1, :integer, :null => false, :default => 0
    add_column :matches, :score_2, :integer, :null => false, :default => 0
  end
end
