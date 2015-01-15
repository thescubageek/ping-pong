class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :match_id
      t.integer :score_1, :null => false, :default => 0
      t.integer :score_2, :null => false, :default => 0
      t.datetime  :date, :null => false, :default => Time.now
    end
  end
end
