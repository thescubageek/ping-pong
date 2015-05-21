class XpRating < ActiveRecord::Base
  belongs_to :player
  belongs_to :match
  validates :value, presence: true
  
  default_scope { order('date DESC, match_id DESC') }
  scope :by_player, ->(player) { where("player_id = ?", player.id) }
  scope :by_match_and_player, ->(match, player) { where("player_id = ? AND match_id = ?", player.id, match.id) }
  scope :by_player_and_date, ->(player, date) { where("player_id = ? AND date >= ? AND date <= ?", player.id, date.beginning_of_day, date.end_of_day)}
  scope :by_player_today, ->(player) { where("player_id = ? AND date >= ? AND date <= ?", player.id, DateTime.now.beginning_of_day, DateTime.now.end_of_day) }

end
