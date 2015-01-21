class DropPlayersTeams < ActiveRecord::Migration
  def change
    drop_table :players_teams
  end
end
