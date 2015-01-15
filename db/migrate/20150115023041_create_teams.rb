class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.integer :player_1_id
      t.integer :player_2_id
    end
  end
end
