class AddEditedPlayerIdToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :edited_player_id, :integer, :default => 0
  end
end
