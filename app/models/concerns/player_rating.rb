module PlayerRating
  extend ActiveSupport::Concern
  
  def player_rating
    match_rating_value.mean + game_rating_value.mean + xp_rating_value
  end

  def player_rating_trend
    return player_rating_trend_diff > 0 ? 1 : (player_rating_trend_diff < 0 ? -1 : 0)
  end

  def player_rating_value
    player_rating
  end

  def previous_player_rating
    prev_game_mean = previous_match_game_rating.value.mean
    prev_match_mean = previous_match_rating.value.mean
    
    prev_match_mean + prev_game_mean + xp_rating_value - PlayerXpRating::MATCH_XP
  end

  def player_rating_trend_diff
    player_rating_value - previous_player_rating
  end
end