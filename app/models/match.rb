include Saulabs::TrueSkill

class Match < ActiveRecord::Base
  EARLIEST_DATE = DateTime.new(2015,1,14)
  MAX_SCORE = 2
  MATCH_MULTIPLIER = 4

  has_many :games, dependent: :destroy
  validates_associated :games
  validates_uniqueness_of :date
  validate :validate_date_after_start_date
  validates :score_1, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: MAX_SCORE }
  validates :score_2, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: MAX_SCORE }

  scope :by_date_desc, -> { order('date DESC') }
  scope :by_date_asc, -> { order('date ASC') }
  scope :by_player, ->(p) { where('player_1_id = ? OR player_2_id = ?', p.id, p.id).order('date DESC') }
  scope :by_players, ->(p1, p2) { where('(player_1_id = ? AND player_2_id = ?) OR (player_1_id = ? AND player_2_id = ?)', p1.id, p2.id, p2.id, p1.id).order('date DESC') }
  scope :by_winner, ->(p) { where('winner_id = ?', p.id).order('date DESC') }
  scope :by_loser, ->(p) { where('loser_id = ?', p.id).order('date DESC') }

  before_save :set_scores

  def set_scores
    self.winner_id = get_winner.try(:id) || 0
    self.loser_id = get_loser.try(:id) || 0
    self.score_1, self.score_2 = get_score
  end

  def validate_date_after_start_date
    if date
      errors.add(:date, "Date is before EARLIEST_DATE") if date < EARLIEST_DATE
    end
  end
  
  def datestr
    date.strftime("%h %d %Y %H:%M")
  end

  ## GAMES

  def score
    [score_1, score_2]
  end

  def game_1
    @game_1 ||= games.first
  end

  def game_1_score_1
    game_1.try(:score_1)
  end

  def game_1_score_2
    game_1.try(:score_2)
  end

  def game_2
    @game_2 ||= games.second
  end

  def game_2_score_1
    game_2.try(:score_1)
  end

  def game_2_score_2
    game_2.try(:score_2)
  end

  def game_3
    @game_3 ||= games.third
  end

  def game_3_score_1
    game_3.try(:score_1)
  end

  def game_3_score_2
    game_3.try(:score_2)
  end

  def get_games
    [game_1, game_2, game_3].compact
  end

  def get_game_number(game)
    get_games.each.with_index(1) do |g, idx|
      return idx if g == game
    end
  end

  ## PLAYERS

  def players
    get_players
  end

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

  ## UPDATERS

  def get_winner
    max_results(winner_results)
  end

  def get_loser
    max_results(loser_results)
  end

  def winner_results
    @winner_results ||= get_games.map { |g| g.winner }
  end

  def loser_results
    @loser_results ||= get_games.map { |g| g.loser }
  end

  def results_array(results)
    results.reduce(Hash.new(0)) { |h, v| h.store(v, h[v] + 1); h }
  end

  def max_results(results)
    results_array(results).max_by { |k,v| v }[0] unless results.empty?
  end

  def get_score
    score_1 = score_2 = 0
    winner_results.each do |ret|
      if ret == player_1
        score_1 += 1
      elsif ret == player_2
        score_2 += 1
      end
    end
    [score_1, score_2]
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

  def opponent(player)
    if player_1 == player
      return player_2
    elsif player_2 == player
      return player_1
    end
  end

  ## RANKINGS

  def update_player_rankings
    get_games.each { |g| update_player_game_rankings(g) }
    update_player_match_rankings
  end

  def update_player_match_rankings
    set_player_rating_groups('match')  
    s1, s2 = get_score
    new_score_1 = (s1 - s2) * MATCH_MULTIPLIER
    new_score_2 = (s2 - s1) * MATCH_MULTIPLIER
    begin
      game_net = ScoreBasedBayesianRating.new(@p1 => new_score_1, @p2 => new_score_2)
      game_net.update_skills
      update_rating_network(game_net, self, 'match')
    rescue => e
      Rails.logger.info(e.message)
      Rails.logger.info(e.backtrace)
    end
  end

  def update_player_game_rankings(game)
    set_player_rating_groups('game')
    begin
      game_net = ScoreBasedBayesianRating.new(@p1 => game.score_1, @p2 => game.score_2)
      game_net.update_skills
      update_rating_network(game_net, game, 'game')
    rescue => e
      Rails.logger.info(e.message)
      Rails.logger.info(e.backtrace)
    end
  end

  def update_rating_network(game_net, object, rating_type)
    action = "update_#{rating_type}_rating".to_sym
    get_players.each_with_index do |p, idx|
      rating = game_net.teams[idx].first
      p.try(action, object, rating.mean, rating.deviation, rating.activity) if rating
    end
  end

  def set_player_rating_groups(rating_type)
    get_players
    rating_val = "#{rating_type}_rating_value".to_sym
    @p1 = [player_1.try(rating_val)]
    @p2 = [player_2.try(rating_val)]
    [@p1, @p2]
  end
end
