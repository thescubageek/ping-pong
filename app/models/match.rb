include Saulabs::TrueSkill

class Match < ActiveRecord::Base
  has_many :games, dependent: :destroy
  has_and_belongs_to_many :players
  validates_associated :games
  validates_associated :players
  validates_uniqueness_of :date
  validate :validate_date_after_start_date
  validates :team_1_player_1, presence: true
  validates :team_2_player_1, presence: true

  default_scope { order('date DESC') }

  def validate_date_after_start_date
    if date
      errors.add(:date, "Put error text here") if date < DateTime.new(2015,1,14)
    end
  end
  
  def datestr
    date.strftime("%h %d %Y %H:%M")
  end

  def max_score
    22 ## hardcoded for now - TODO: make dynamic later
  end

  def get_player_ids
    (team_1_player_2_id && team_2_player_2_id) ? [team_1_player_1_id, team_1_player_2_id, team_2_player_1_id, team_2_player_2_id] : [team_1_player_1_id, team_2_player_1_id]
  end

  def get_players
    self.players = get_player_ids.map { |pid| Player.find_by_id(pid) }
  end

  def team_1
    team_1_player_2 ? [team_1_player_1, team_1_player_2] : [team_1_player_1]
  end

  def team_2
    team_2_player_2 ? [team_2_player_1, team_2_player_2] : [team_2_player_1]
  end

  def team_1_player_1
    players.select { |p| p.id == team_1_player_1_id }.first
  end

  def team_1_player_2
    players.select { |p| p.id == team_1_player_2_id }.first
  end

  def team_2_player_1
    players.select { |p| p.id == team_2_player_1_id }.first
  end

  def team_2_player_2
    players.select { |p| p.id == team_2_player_2_id }.first
  end

  def game_1
    games.first
  end

  def game_2
    games.second
  end

  def game_3
    games.third
  end

  def game_1_score_1
    game_1.score_1 if game_1
  end

  def game_1_score_2
    game_1.score_2 if game_1
  end

  def game_2_score_1
    game_2.score_1 if game_2
  end

  def game_2_score_2
    game_2.score_2 if game_2
  end

  def game_3_score_1
    game_3.score_1 if game_3
  end

  def game_3_score_2
    game_3.score_2 if game_3
  end

  def winner
    results = game_3 ? [game_1.winner, game_2.winner, game_3.winner] : [game_1.winner, game_2.winner]
    max_results(results)
  end

  def loser
    results = game_3 ? [game_1.loser, game_2.loser, game_3.loser] : [game_1.loser, game_2.loser]
    max_results(results)
  end

  def max_results(results)
    results.reduce(Hash.new(0)) { |h, v| h.store(v, h[v] + 1); h }.max_by { |k,v| v }[0]
  end

  def is_winner?(team)
    winner ? team == winner : false
  end

  def is_loser?(team)
    loser ? team == loser : false
  end

  def is_winning_player?(player)
    winner.include?(player)
  end

  def is_losing_player?(player)
    loser.include?(player)
  end

  def winner_player_1
    winner.player_1
  end

  def winner_player_2
    winner.player_2
  end

  def loser_player_1
    loser.player_1
  end

  def loser_player_2
    loser.player_2
  end

  def has_player?(player)
    team_1.include?(player) || team_2.include?(player)
  end

  def teammate(player)
    if team_1.include?(player)
      return team_1.reject { |p| p.id == player.id }.first
    elsif team_2.include?(player)
      return team_2.reject { |p| p.id == player.id }.first
    end
  end

  def opponents(player)
    if team_1.include?(player)
      return team_2
    elsif team_2.include?(player)
      return team_1
    end
    nil
  end

  def self.by_date_asc
    self.all.sort_by(&:date)
  end

  def self.by_team(team)
    self.all.select { |m| m.has_team?(team) } if team
  end

  def self.by_player(player)
    self.all.select { |m| m.has_player?(player) } if player
  end

  def self.by_winning_player(player)
    self.by_player(player).select { |m| m.is_winning_player?(player) } if player
  end

  def self.by_losing_player(player)
    self.by_player(player).select { |m| m.is_losing_player?(player) } if player
  end

  def update_player_rankings
    get_players
    @p1 = team_1_player_2 ? [team_1_player_1.player_rating_value, team_1_player_2.player_rating_value] : [team_1_player_1.player_rating_value]
    @p2 = team_2_player_2 ? [team_2_player_1.player_rating_value, team_2_player_2.player_rating_value] : [team_2_player_1.player_rating_value]

    update_player_game_rankings(game_1) if game_1
    update_player_game_rankings(game_2) if game_2
    update_player_game_rankings(game_3) if game_3

    team_1_player_1.update_player_match_rating(self)
    team_1_player_2.update_player_match_rating(self) if team_1_player_2
    team_2_player_1.update_player_match_rating(self)
    team_2_player_2.update_player_match_rating(self) if team_2_player_2
  end

  def update_player_game_rankings(game)
    game_net = ScoreBasedBayesianRating.new(@p1 => game.score_1, @p2 => game.score_2)
    game_net.update_skills

    rating = game_net.teams.first.first
    team_1_player_1.update_player_rating(game, rating.mean, rating.deviation, rating.activity) if rating

    rating = game_net.teams.first.second
    team_1_player_2.update_player_rating(game, rating.mean, rating.deviation, rating.activity) if rating

    rating = game_net.teams.second.first
    team_2_player_1.update_player_rating(game, rating.mean, rating.deviation, rating.activity) if rating

    rating = game_net.teams.second.second
    team_2_player_2.update_player_rating(game, rating.mean, rating.deviation, rating.activity) if rating
  end
end
