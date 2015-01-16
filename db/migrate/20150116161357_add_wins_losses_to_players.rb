class AddWinsLossesToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :match_wins, :integer, :default => 0
    add_column :players, :match_losses, :integer, :default => 0
    add_column :players, :game_wins, :integer, :default => 0
    add_column :players, :game_losses, :integer, :default => 0
  end
end
