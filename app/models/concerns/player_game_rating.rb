module PlayerGameRating
  extend ActiveSupport::Concern
  
  def game_rating
    return game_ratings.first unless game_ratings.empty?
    rating = GameRating.new({player_id: self.id})
    rating.save
    rating.reload
  end

  def current_match_game_rating
    match = matches.first
    game = match.get_games.last if match
    rating = GameRating.by_game_and_player(game, self).try(:first) if game
    rating || game_ratings.last
  end

  def previous_match_game_rating
    match = matches.second
    game = match.get_games.last if match
    rating = GameRating.by_game_and_player(game, self).try(:first) if game
    rating || game_ratings.last
  end

  def game_rating_value
    game_rating.value
  end

  def game_rating_trend
    return game_rating_trend_diff > 0 ? 1 : (game_rating_trend_diff < 0 ? -1 : 0)
  end

  def game_rating_trend_diff
    pr1 = current_match_game_rating
    pr2 = previous_match_game_rating
    return (pr1 && pr2) ? pr1.value.mean - pr2.value.mean : 0
  end

  def update_game_rating(game, mean, deviation, activity)
    if game.is_winner?(self)
      self.update_attributes({game_wins: game_wins+1})
    else
      self.update_attributes({game_losses: game_losses+1})
    end
    rating = GameRating.new({player_id: self.id, game_id: game.id, mean: mean, deviation: deviation, activity: activity, date: game.date})
    rating.save
  end
end