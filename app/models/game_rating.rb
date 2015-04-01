include Saulabs::TrueSkill

class GameRating < ActiveRecord::Base
  belongs_to :player
  belongs_to :game
  validates :mean, presence: true
  validates :deviation, presence: true
  validates :activity, presence: true

  default_scope { order('date DESC, game_id DESC') }
  scope :by_player, ->(player) { where("player_id = ?", player.id) }
  scope :by_game_and_player, ->(game, player) { where("player_id = ? AND game_id = ?", player.id, game.id) }

  def value
    Rating.new(mean, deviation, activity)
  end
end
