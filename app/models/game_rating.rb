include Saulabs::TrueSkill

class GameRating < ActiveRecord::Base
  belongs_to :player
  belongs_to :game
  validates :mean, presence: true
  validates :deviation, presence: true
  validates :activity, presence: true

  default_scope { order('date DESC, game_id DESC') }

  def value
    Rating.new(mean, deviation, activity)
  end

  def self.by_player(player)
    self.where("player_id = ?", player.id)
  end

  def self.by_game_and_player(game, player)
    self.where("player_id = ? AND game_id = ?", player.id, game.id)
  end
end
