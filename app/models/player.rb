class Player < ActiveRecord::Base
  has_many :game_ratings, dependent: :destroy
  has_many :match_ratings, dependent: :destroy
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates_uniqueness_of :first_name, :scope => :last_name, :case_sensitive => false
  validates_uniqueness_of :email, :case_sensitive => false

  default_scope { order('trueskill DESC, first_name ASC, last_name ASC') }
  scope :by_name, -> { order('first_name ASC, last_name ASC') }
  scope :no_zeros, -> { includes(:match_ratings).includes(:game_ratings).where('match_wins != 0 OR match_losses != 0').order('trueskill DESC, first_name DESC, last_name DESC') }
  scope :only_zeros, -> { where('match_wins = 0 AND match_losses = 0').order('trueskill DESC, first_name DESC, last_name DESC') }
  scope :by_email, ->(email) { where('email = ?', email) }

  def calculate_trueskill
    player_rating
  end

  def name
    "#{first_name} #{last_name}"
  end

  ## PLAYER RECORD

  def wins
    match_wins
  end

  def calculate_match_wins
    matches.by_winner(self).size
  end

  def losses
    match_losses
  end

  def calculate_match_losses
    matches.by_loser(self).size
  end

  def draws
    0 # no draws allowed!
  end

  def matches
    @matches ||= Match.by_player(self)
  end

  def matches_played
    match_wins + match_losses
  end

  def calculate_matches_played
    matches.size
  end

  ## GAMES

  def games
    Game.includes(:match).by_player(self)
  end

  def games_played
    game_wins + game_losses
  end

  def calculate_games_played
    games.size
  end

  def calculate_game_wins
    Game.by_winner(self).size
  end

  def calculate_game_losses
    Game.by_loser(self).size
  end

  ## GAME MATCHUPS

  def self.by_games_won_against(player)
    self.no_zeros.inject([]) { |arr,p| 
      arr << {player: p, games: player.games_won_against(p).size} unless p.id == player.id
      arr
    }.sort {|a,b| b[:games] <=> a[:games] }
  end

  def games_won_against(opponent)
    games_played_against(opponent).select { |g| g.is_winner?(self) }
  end

  def self.by_games_lost_against(player)
    self.no_zeros.inject([]) { |arr,p| 
      arr << {player: p, games: player.games_lost_against(p).size} unless p.id == player.id
      arr
    }.sort {|a,b| b[:games] <=> a[:games] }
  end

  def games_lost_against(opponent)
    games_played_against(opponent).select { |g| g.is_loser?(self) }
  end

  def self.by_games_played_against(player)
    self.no_zeros.inject([]) { |arr,p| 
      arr << {player: p, games: player.games_played_against(p).size} unless p.id == player.id
      arr
    }.sort {|a,b| b[:games] <=> a[:games] }
  end

  def games_played_against(opponent)
    Game.by_players(self, opponent)
  end

  def self.by_games_played_against(player)
    self.no_zeros.inject([]) { |arr,p|
      arr << {player: p, games: player.games_played_against(p).size} unless p.id == player.id
      arr
    }.sort {|a,b| b[:games] <=> a[:games] }
  end

  def select_top_players_by_games(players, game_count)
    players.inject([]) do |arr, p| 
      arr << p[:player] if p[:games] == game_count
      arr
    end
  end

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

  def ranking(no_zeros=false)
    prs = Player.ranking_groups(no_zeros)
    pos = 1
    prs.each_with_index do |(k, v), i|
      return pos if trueskill == k
      pos += v
    end
    pos
  end

  def is_zero?
    games_played == 0 && matches_played == 0
  end

  def self.ranking_groups(no_zeros=false)
    players = no_zeros ? Player.no_zeros : Player.all
    prs = players.map { |p| p.trueskill }.sort.reverse
    prs.inject(Hash.new(0)) { |total, e| total[e] += 1 ; total}
  end

  ## PLAYER RATING

  def player_rating
    match_rating_value.mean + game_rating_value.mean
  end

  def player_rating_trend
    return player_rating_trend_diff > 0 ? 1 : (player_rating_trend_diff < 0 ? -1 : 0)
  end

  def player_rating_value
    player_rating
  end

  def previous_player_rating
    prev_game = previous_match_game_rating.value.mean
    prev_match = previous_match_rating.value.mean
    prev_match + prev_game
  end

  def player_rating_trend_diff
    player_rating_value - previous_player_rating
  end

  ## GAME RATING
  
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

  ## MATCH RATING

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
    update_attribute(:trueskill, calculate_trueskill)
  end

  ## rivalries

  def update_player_rivalries
    self.update_attributes({
      rival_id: calculate_rival.try(:id) || 0,
      punching_bag_id: calculate_punching_bag.try(:id) || 0,
      nemesis_id: calculate_nemesis.try(:id) || 0
    })
  end
end
