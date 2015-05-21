module PlayerMatchRating
  extend ActiveSupport::Concern
  
  def match_rating
    return match_ratings.first unless match_ratings.empty?
    rating = MatchRating.new({player_id: self.id})
    rating.save
    rating.reload
  end

  def previous_match_rating
    match_ratings.second || match_ratings.last
  end

  def match_rating_value
    match_rating.value
  end

  def match_rating_trend
    return match_rating_trend_diff > 0 ? 1 : (match_rating_trend_diff < 0 ? -1 : 0)
  end

  def match_rating_trend_diff
     recent = match_ratings.first
     prev = match_ratings.second
     prev ? recent.value.mean - prev.value.mean : 0
  end

  def update_match_rating(match, mean, deviation, activity)
    if match.is_winner?(self)
      self.update_attributes({match_wins: match_wins+1})
    else
      self.update_attributes({match_losses: match_losses+1})
    end
    rating = MatchRating.new({player_id: self.id, match_id: match.id, mean: mean, deviation: deviation, activity: activity, date: match.date})
    rating.save
    
    update_xp_rating(match)
    update_attribute(:trueskill, calculate_trueskill)
    update_player_rivalries
  end
end