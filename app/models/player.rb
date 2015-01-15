include Saulabs::TrueSkill

class Player < ActiveRecord::Base
  has_and_belongs_to_many :teams
  validates :first_name, presence: true
  validates :last_name, presence: true

  def self.by_trueskill
    self.all.sort { |a, b| a.trueskill <=> b.trueskill }
  end

  def trueskill
    5 ## TODO update this
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
    Player.by_trueskill.index(self) + 1
  end
end
