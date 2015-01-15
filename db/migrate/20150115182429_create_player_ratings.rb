class CreatePlayerRatings < ActiveRecord::Migration
  def change
    create_table :player_ratings do |t|
      t.integer :player_id, null: false
      t.float :mean, null: false, default: 25.0
      t.float :deviation, null: false, default: 2.0
      t.float :activity, null: false, default: 1.0
      
      t.datetime :date, null: false, default: Time.now()
    end
  end
end
