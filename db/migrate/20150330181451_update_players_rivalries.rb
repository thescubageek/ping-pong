class UpdatePlayersRivalries < ActiveRecord::Migration
  def change
    remove_column :players, :best_buddy_id
    remove_column :players, :dynamic_duo_id
    remove_column :players, :ball_and_chain_id
  end
end
