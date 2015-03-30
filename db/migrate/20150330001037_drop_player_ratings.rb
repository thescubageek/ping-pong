class DropPlayerRatings < ActiveRecord::Migration
  def change
    drop_table :player_ratings
    Player.all.each { |p| p.update_attribute(:trueskill, p.calculate_trueskill) }
  end
end
