include Saulabs::TrueSkill

class PlayerRating < ActiveRecord::Base
  belongs_to :player
  belongs_to :game
  validates :mean, presence: true
  validates :deviation, presence: true
  validates :activity, presence: true

  default_scope { order('date DESC') }

  def value
    Rating.new(mean, deviation, activity)
  end

  def self.by_player(player)
    self.where("player_id = ?", player.id)
  end
end
