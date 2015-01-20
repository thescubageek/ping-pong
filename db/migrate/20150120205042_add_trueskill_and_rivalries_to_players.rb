class AddTrueskillAndRivalriesToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :trueskill, :float, :default => 25
    add_column :players, :best_buddy_id, :integer, :default => 0
    add_column :players, :dynamic_duo_id, :integer, :default => 0
    add_column :players, :ball_and_chain_id, :integer, :default => 0
    add_column :players, :rival_id, :integer, :default => 0
    add_column :players, :punching_bag_id, :integer, :default => 0
    add_column :players, :nemesis_id, :integer, :default => 0
  end
end
