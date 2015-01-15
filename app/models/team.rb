class Team < ActiveRecord::Base
  has_and_belongs_to_many :players
  belongs_to :match
  validates_associated :players

  def player_1
    players.first
  end

  def player_2
    players.second
  end

  def has_player?(player)
    !!(players.find_by_id(player.id) if player)
  end

  def self.find_by_player(player)
    self.all.select { |t| t.has_player?(player) } if player
  end
end
