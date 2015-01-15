class Game < ActiveRecord::Base
  belongs_to :match
  has_many :teams, through: :match
  has_many :players, through: :team
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
end
