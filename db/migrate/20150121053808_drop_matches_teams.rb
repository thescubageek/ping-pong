class DropMatchesTeams < ActiveRecord::Migration
  def change
    drop_table :matches_teams
  end
end
