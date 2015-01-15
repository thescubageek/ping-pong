class AddGameIdToPlayerRatings < ActiveRecord::Migration
  def change
     add_column :games, :game_id, :integer, null: false, default: 0
  end
end
