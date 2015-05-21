class Game < ActiveRecord::Base
  MAX_SCORE = 22

  belongs_to :match
  has_many :game_ratings, dependent: :destroy
  
  validate :no_draws
  validates :score_1, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: MAX_SCORE }
  validates :score_2, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: MAX_SCORE }

  default_scope { order('date DESC, id ASC') }
  scope :by_date_asc, -> { order('date ASC, id ASC') }
  scope :by_player, ->(p) { where('player_1_id = ? OR player_2_id = ?', p.id, p.id).order('date DESC, id ASC') }
  scope :by_players, ->(p1, p2) { where('(player_1_id = ? AND player_2_id = ?) OR (player_1_id = ? AND player_2_id = ?)', p1.id, p2.id, p2.id, p1.id).order('date DESC, id ASC') }
  scope :by_winner, ->(p) { where('winner_id = ?', p.id).order('date DESC, id ASC') }
  scope :by_loser, ->(p) { where('loser_id = ?', p.id).order('date DESC, id ASC') }

  before_save :set_scores

  def set_scores
    self.winner_id = get_winner.try(:id) || 0
    self.loser_id = get_loser.try(:id) || 0
  end

  def score
    [score_1, score_2]
  end

  def draw
    score_1.to_i == score_2.to_i
  end

  def no_draws
    !draw
  end

  ## PLAYERS

  def get_players
    [player_1, player_2]
  end

  def player_1
    @player_1 ||= Player.find_by_id(player_1_id)
  end

  def player_2
    @player_2 ||= Player.find_by_id(player_2_id)
  end

  def winner
    @winner ||= Player.find_by_id(winner_id)
  end

  def loser
    @loser ||= Player.find_by_id(loser_id)
  end


  def get_winner
    unless draw
      score_1.to_i > score_2.to_i ? player_1 : player_2
    end
  end

  def get_loser
    unless draw
      score_1.to_i < score_2.to_i ? player_1 : player_2
    end
  end

  def game_number
    match.get_game_number(self)
  end

  def is_winner?(player)
    winner == player
  end

  def is_loser?(player)
    loser == player
  end

  def has_player?(player)
    player_1 == player || player_2 == player
  end

  def are_opponents?(p1, p2)
    opponent(p1) == p2
  end

  def opponent(player)
    if player_1 == player
      return player_2
    elsif player_2 == player
      return player_1
    end
  end
end
