class CreateMatchRatings < ActiveRecord::Migration
  def change
    create_table :match_ratings do |t|
      t.integer :player_id, null: false
      t.integer :match_id, null: false, default: 0
      t.float :mean, null: false, default: 50.0
      t.float :deviation, null: false, default: 2.0
      t.float :activity, null: false, default: 1.0
      
      t.datetime :date, null: false, default: Time.now()
    end
  end
end

