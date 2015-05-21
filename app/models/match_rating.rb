include Saulabs::TrueSkill

class MatchRating < ActiveRecord::Base
  belongs_to :player
  belongs_to :match
  validates :mean, presence: true
  validates :deviation, presence: true
  validates :activity, presence: true

  default_scope { order('date DESC, match_id DESC') }
  scope :by_player, ->(player) { where("player_id = ?", player.id) }
  scope :by_match_and_player, ->(match, player) { where("player_id = ? AND match_id = ?", player.id, match.id) }

  def value
    Rating.new(mean, deviation, activity)
  end
end
