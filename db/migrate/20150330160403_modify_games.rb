class ModifyGames < ActiveRecord::Migration
  def change
    add_column :games, :player_1_id, :integer, :null => false, :default => 0
    add_column :games, :player_2_id, :integer, :null => false, :default => 0
    add_column :games, :winner_id, :integer, :null => false, :default => 0
    add_column :games, :loser_id, :integer, :null => false, :default => 0

    Game.all.each do |g|
      m = g.match
      g.update_attributes({
        player_1_id: m.team_1_player_1_id,
        player_2_id: m.team_2_player_1_id,
        winner_id: (g.score_1 > g.score_2) ? m.team_1_player_1_id : m.team_2_player_1_id,
        loser_id: (g.score_1 > g.score_2) ? m.team_2_player_1_id : m.team_1_player_1_id
      })
    end
  end
end
