class Game < ActiveRecord::Base
  belongs_to :match
  has_many :teams, through: :match
  has_many :players, through: :team
  has_many :player_ratings
  validates :score_1, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 22 }
  validates :score_2, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 22 }


  def draw
    score_1.to_i == score_2.to_i
  end

  def winner
    unless draw
      score_1.to_i > score_2.to_i ? team_1 : team_2
    end
  end

  def loser
    unless draw
      score_1.to_i < score_2.to_i ? team_1 : team_2
    end
  end

  def team_1
    match.team_1
  end

  def team_2
    match.team_2
  end

  def has_team?(team)
    match.has_team?(team)
  end

  def has_player?(player)
    match.has_player?(player)
  end

  def is_winner?(team)
    winner.id == team.id if team
  end

  def is_loser?(team)
    loser.id == team.id if team
  end

  def is_winning_player?(player)
    winner.has_player?(player) if player
  end

  def is_losing_player?(player)
    loser.has_player?(player) if player
  end

  def are_opponents?(player1, player2)
    (has_player?(player1) && has_player?(player2) && !team_1.has_teammates(player1, player2) && !team_2.has_teammates(player1, player2))
  end

  def are_teammates?(player1, player2)
    (has_player?(player1) && has_player?(player2) && (team_1.has_teammates(player1, player2) || team_2.has_teammates(player1, player2)))
  end

  def opponent_team(player)
    if team_1.has_player?(player)
      return team_2
    elsif team_2.has_player?(player)
      return team_1
    end
  end

  def opponent_players(player)
    team = opponent_team(player)
    team.players if team
  end

  def teammate(player)
    match.teammate(player)
  end

  def self.by_team(team)
    self.all.select { |g| g.has_team?(team) } if team
  end

  def self.by_player(player)
    self.all.select { |g| g.has_player?(player) } if player
  end

  def self.by_winning_team(team)
    self.all.select { |g| g.is_winner?(team) } if team
  end

  def self.by_losing_team(team)
    self.all.select { |m| g.is_loser?(team) } if team
  end

  def self.by_winning_player(player)
    self.all.select { |g| g.is_winning_player?(player) } if player
  end

  def self.by_losing_player(player)
    self.all.select { |g| g.is_losing_player?(player) } if player
  end

  def self.by_player_teammate(player, teammate)
    self.by_player(player).select { |g| g.teammate(player).try(:id) == teammate.id }
  end

  def self.by_player_opponent(player, opponent)
    self.by_player(player).select { |g| g.opponent_players(player).map(&:id).include?(opponent.id) }
  end
end
