class CreateXpRatings < ActiveRecord::Migration
  def change
    create_table :xp_ratings do |t|
      t.integer :player_id, null: false
      t.integer :match_id, null: false, default: 0
      t.float :value, null: false, default: 0.1
      t.string :name, null: false, default: "Match XP"
      
      t.datetime :date, null: false, default: Time.now()
    end

    RankingUpdater.update
  end
end
