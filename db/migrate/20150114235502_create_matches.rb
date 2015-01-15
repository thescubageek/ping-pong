class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :team_1_id
      t.integer :team_2_id
      t.datetime :date, :null => false, :default => Time.now
    end
  end
end
