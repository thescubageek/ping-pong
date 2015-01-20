include Saulabs::TrueSkill

class Match < ActiveRecord::Base
  has_many :games, dependent: :destroy
  has_and_belongs_to_many :teams
  validates_associated :games
  validates_associated :teams
  validates_uniqueness_of :date

  default_scope { order('date DESC') }
  scope :by_date_asc, -> { order('date ASC') }

  def datestr
    date.strftime("%h %d %Y %H:%M")
  end

  def team_1
    teams.first
  end

  def team_2
    teams.second
  end

  def team_1_player_1
    team_1.player_1 if team_1
  end

  def team_1_player_2
    team_1.player_2 if team_1
  end

  def team_2_player_1
    team_2.player_1 if team_2
  end

  def team_2_player_2
    team_2.player_2 if team_2
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
    winner ? team.id == winner.id : false
  end

  def is_loser?(team)
    loser ? team.id == loser.id : false
  end

  def is_winning_player?(player)
    winner.has_player?(player)
  end

  def is_losing_player?(player)
    loser.has_player?(player)
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

  def has_team?(team)
    team_1_id == team.id || team_2_id == team.id
  end

  def has_player?(player)
    team_1.has_player?(player) || team_2.has_player?(player)
  end

  def teammate(player)
    if team_1.has_player?(player)
      return team_1.players.reject { |p| p.id == player.id }.first
    elsif team_2.has_player?(player)
      return team_2.players.reject { |p| p.id == player.id }.first
    end
  end

  def opposing_team(player)
    if team_1.has_player?(player)
      return team_2
    elsif team_2.has_player?(player)
      return team_1
    end
    nil
  end

  def opponents(player)
    opp = opposing_team(player)
    [opp.player_1, opp.player_2] if opp
  end

  def self.by_team(team)
    self.all.select { |m| m.has_team?(team) } if team
  end

  def self.by_player(player)
    self.all.select { |m| m.has_player?(player) } if player
  end

  def self.by_winning_team(team)
    self.all.select { |m| m.is_winner?(team) } if team
  end

  def self.by_losing_team(team)
    self.all.select { |m| m.is_loser?(team) } if team
  end

  def self.by_winning_player(player)
    self.all.select { |m| m.is_winning_player?(player) } if player
  end

  def self.by_losing_player(player)
    self.all.select { |m| m.is_losing_player?(player) } if player
  end

  def update_player_rankings
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
