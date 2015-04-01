class Player < ActiveRecord::Base
  include PlayerGameRating
  include PlayerMatchRating
  include PlayerXpRating
  include PlayerRating
  include PlayerRivalries

  has_many :game_ratings, dependent: :destroy
  has_many :match_ratings, dependent: :destroy
  has_many :xp_ratings, dependent: :destroy
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates_uniqueness_of :first_name, :scope => :last_name, :case_sensitive => false
  validates_uniqueness_of :email, :case_sensitive => false

  default_scope { order('trueskill DESC, first_name ASC, last_name ASC') }
  scope :by_name, -> { order('first_name ASC, last_name ASC') }
  scope :no_zeros, -> { where('match_wins != 0 OR match_losses != 0') }
  scope :only_zeros, -> { where('match_wins = 0 AND match_losses = 0') }
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

  ## RANKINGS

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

end
