class ModifyMatches < ActiveRecord::Migration
  def change
    add_column :matches, :player_1_id, :integer, :null => false, :default => 0
    add_column :matches, :player_2_id, :integer, :null => false, :default => 0
    add_column :matches, :winner_id, :integer, :null => false, :default => 0
    add_column :matches, :loser_id, :integer, :null => false, :default => 0
    add_column :matches, :score_1, :integer, :null => false, :default => 0
    add_column :matches, :score_2, :integer, :null => false, :default => 0

    Match.all.each do |m|
      score_1, score_2 = m.get_score
      m.update_attributes({
        player_1_id: m.team_1_player_1.id,
        player_2_id: m.team_2_player_1.id,
        winner_id: (score_1 > score_2 ? m.team_1_player_1.id : m.team_2_player_1.id),
        loser_id: (score_1 > score_2 ? m.team_2_player_1.id : m.team_1_player_1.id),
        score_1: score_1,
        score_2: score_2
      })
    end

    remove_column :matches, :team_1_player_1_id
    remove_column :matches, :team_1_player_2_id
    remove_column :matches, :team_2_player_1_id
    remove_column :matches, :team_2_player_2_id
  end
end
