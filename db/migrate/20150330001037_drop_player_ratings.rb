class DropPlayerRatings < ActiveRecord::Migration
  def change
    drop_table :player_ratings
  end
end
