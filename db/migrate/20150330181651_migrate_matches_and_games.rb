class MigrateMatchesAndGames < ActiveRecord::Migration
  def change
    migrate_games
    migrate_matches
  end

  def migrate_games
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

  def migrate_matches
    Match.all.each do |m|
      m.update_attributes({
        player_1_id: m.team_1_player_1_id,
        player_2_id: m.team_2_player_1_id
      })
      score_1, score_2 = m.get_score

      m.update_attributes({
        score_1: score_1,
        score_2: score_2,
        winner_id: (score_1 > score_2 ? m.team_1_player_1_id : m.team_2_player_1_id),
        loser_id: (score_1 > score_2 ? m.team_2_player_1_id : m.team_1_player_1_id)
      })
    end
  end
end
