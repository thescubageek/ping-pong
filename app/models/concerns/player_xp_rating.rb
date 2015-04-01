module PlayerXpRating
  extend ActiveSupport::Concern

  MATCH_XP = 0.1
  
  ## XP RATING
  def xp_rating
    xp_ratings.where('date >= ?', 30.days.ago).inject(0) { |sum, xp| sum + xp.value }
  end

  def xp_rating_value
    xp_rating
  end

  def update_xp_rating(match)
    award_match_xp(match)
  end

  def award_xp(match, value, name)
    xp = XpRating.new({player_id: self.id, match_id: match.id, value: value, name: name, date: match.date}) if match
    xp.save if xp
    xp
  end

  def award_match_xp(match)
    award_xp(match, MATCH_XP, "Match XP")
  end

end