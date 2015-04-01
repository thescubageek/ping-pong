module PlayerRivalries
  extend ActiveSupport::Concern

#  def best_buddy
#    Player.find_by_id(best_buddy_id)
#  end
#
#  def calculate_best_buddy
#    pl = Player.by_games_played_with(self)
#    max_games = pl.first[:games] unless pl.empty?
#    if max_games && max_games > 0
#      players = select_top_players_by_games(pl, max_games)
#      players.sort { |a, b| a.games_won_with(self).size <=> b.games_won_with(self).size }.first
#    end
#  end
#
#  def dynamic_duo
#    Player.find_by_id(dynamic_duo_id)
#  end
#
#  def calculate_dynamic_duo
#    pl = Player.by_games_won_with(self)
#    max_games = pl.first[:games] unless pl.empty?
#    if max_games && max_games > 0
#      players = select_top_players_by_games(pl, max_games)
#      players.sort { |a, b| a.games_played_with(self).size <=> b.games_played_with(self).size }.first
#    end
#  end
#
#  def ball_and_chain
#    Player.find_by_id(ball_and_chain_id)
#  end
#
#  def calculate_ball_and_chain
#    pl = Player.by_games_lost_with(self)
#    max_games = pl.first[:games] unless pl.empty?
#    if max_games && max_games > 0
#      players = select_top_players_by_games(pl, max_games)
#      players.sort { |a, b| a.games_played_with(self).size <=> b.games_played_with(self).size }.first
#      players.first
#    end
#  end

  ## RIVALRIES

  def nemesis
    Player.find_by_id(nemesis_id)
  end

  def calculate_nemesis
    pl = Player.by_games_lost_against(self)
    max_games = pl.first[:games] unless pl.empty?
    if max_games && max_games > 0
      players = select_top_players_by_games(pl, max_games)
      players.sort { |a, b| a.games_played_against(self).size <=> b.games_played_against(self).size }.first
      players.first
    end
  end

  def rival
    Player.find_by_id(rival_id)
  end

  def calculate_rival
    pl = Player.by_games_played_against(self)
    max_games = pl.first[:games] unless pl.empty?
    if max_games && max_games > 0
      players = select_top_players_by_games(pl, max_games)
      players.sort { |a, b| (self.trueskill - a.trueskill).abs <=> (self.trueskill - b.trueskill).abs }.first
      players.first
    end
  end

  def punching_bag
    Player.find_by_id(punching_bag_id)
  end

  def calculate_punching_bag
    pl = Player.by_games_won_against(self)
    max_games = pl.first[:games] unless pl.empty?
    if max_games && max_games > 0
      players = select_top_players_by_games(pl, max_games)
      players.sort { |a, b| a.games_played_against(self).size <=> b.games_played_against(self).size }.first
      players.first
    end
  end

  def update_player_rivalries
    self.update_attributes({
      rival_id: calculate_rival.try(:id) || 0,
      punching_bag_id: calculate_punching_bag.try(:id) || 0,
      nemesis_id: calculate_nemesis.try(:id) || 0
    })
  end
end