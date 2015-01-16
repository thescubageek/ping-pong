class Player < ActiveRecord::Base
  has_and_belongs_to_many :teams
  has_many :player_ratings
  validates :first_name, presence: true
  validates :last_name, presence: true

  default_scope { order('first_name DESC, last_name DESC') }

  def self.by_trueskill
    self.all.sort { |a, b| a.trueskill <=> b.trueskill }.reverse
  end

  def self.by_no_zeros
    self.all.select { |p| !p.is_zero? }.sort { |a, b| a.trueskill <=> b.trueskill }.reverse
  end

  def trueskill
    player_rating.mean
  end

  def name
    "#{first_name} #{last_name}"
  end

  def wins
    Match.by_winning_player(self).size
  end

  def losses
    Match.by_losing_player(self).size
  end

  def draws
    0
  end

  def matches
    Match.by_player(self)
  end

  def matches_played
    matches.size
  end

  def games
    Game.by_player(self)
  end

  def games_played
    games.size
  end

  def game_wins
    Game.by_winning_player(self).size
  end

  def game_losses
    Game.by_losing_player(self).size
  end

  def ranking
    prs = Player.ranking_groups
    pos = 1
    prs.each_with_index do |(k, v), i|
      if trueskill == k
        return pos
      else
        pos += v
      end
    end
    pos
  end

  def is_zero?
    games.size == 0
  end

  def self.ranking_groups
    prs = Player.all.map { |p| p.trueskill }.sort.reverse
    prs.inject(Hash.new(0)) { |total, e| total[e] += 1 ; total}
  end

  def player_ratings
    PlayerRating.by_player(self)
  end

  def player_rating
    return player_ratings.first unless player_ratings.empty?
    pr = PlayerRating.new({player_id: self.id})
    pr.save
    pr.reload
  end

  def player_rating_value
    player_rating.value
  end

  def player_rating_trend
    return player_rating_trend_diff > 0 ? 1 : (player_rating_trend_diff < 0 ? -1 : 0)
  end

  def player_rating_trend_diff
    recent = matches.first
    previous = matches.second
    if recent && previous
      recent_game = recent.games.last
      prev_game = previous.games.last
      pr1 = PlayerRating.by_game_and_player(recent_game, self).first
      pr2 = PlayerRating.by_game_and_player(prev_game, self).first
    elsif recent && !previous
      recent_game = recent.games.last
      pr1 = PlayerRating.by_game_and_player(recent_game, self).first
      pr2 = player_ratings.last
    end

    return (pr1 && pr2) ? pr1.value.mean - pr2.value.mean : 0
  end

  def update_player_rating(game, mean, deviation, activity)
    pr = PlayerRating.new({player_id: self.id, game_id: game.id, mean: mean, deviation: deviation, activity: activity})
    pr.save
  end
end
