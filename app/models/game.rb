class Game < ActiveRecord::Base
  belongs_to :match
  has_many :players, through: :match
  has_many :player_ratings, dependent: :destroy
  validates :score_1, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 22 }
  validates :score_2, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 22 }

  default_scope { order('date DESC') }
  scope :by_date_asc, -> { order('date ASC') }

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

  def game_number
    return 1 if match.game_1 == self
    return 2 if match.game_2 == self
    return 3 if match.game_3 == self
  end

  def has_player?(player)
    match.has_player?(player)
  end

  def is_winning_player?(player)
    winner.include?(player) if player && winner
  end

  def is_losing_player?(player)
    loser.include?(player) if player && loser
  end

  def are_opponents?(player1, player2)
    (has_player?(player1) && has_player?(player2) && !team_1.has_teammates(player1, player2) && !team_2.has_teammates(player1, player2))
  end

  def are_teammates?(player1, player2)
    (has_player?(player1) && has_player?(player2) && (team_1.has_teammates(player1, player2) || team_2.has_teammates(player1, player2)))
  end

  def opponents(player)
    match.opponents(player)
  end

  def teammate(player)
    match.teammate(player)
  end

  def self.by_player(player)
    self.all.select { |g| g.has_player?(player) } if player
  end

  def self.by_winning_player(player)
    self.by_player(player).select { |g| g.is_winning_player?(player) } if player
  end

  def self.by_losing_player(player)
    self.by_player(player).select { |g| g.is_losing_player?(player) } if player
  end

  def self.by_player_teammate(player, teammate)
    self.by_player(player).select { |g| g.teammate(player).try(:id) == teammate.id }
  end

  def self.by_player_opponent(player, opponent)
    self.by_player(player).select { |g| g.opponents(player).map(&:id).include?(opponent.id) }
  end
end
