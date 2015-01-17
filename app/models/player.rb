class Player < ActiveRecord::Base
  has_and_belongs_to_many :teams
  has_many :player_ratings
  validates :first_name, presence: true
  validates :last_name, presence: true

  default_scope { order('first_name DESC, last_name DESC') }

  def self.by_trueskill
    self.includes(:player_ratings).all.sort { |a, b| a.trueskill <=> b.trueskill }.reverse
  end

  def self.by_no_zeros
    self.all.select { |p| !p.is_zero? }.sort { |a, b| a.trueskill <=> b.trueskill }.reverse
  end

  def trueskill
    player_rating.mean
  end

  def name
    "#{first_name} #{last_name}"
  end

  def wins
    match_wins
  end

  def calculate_match_wins
    Match.by_winning_player(self).size
  end

  def losses
    match_losses
  end

  def calculate_match_losses
    Match.by_losing_player(self).size
  end

  def draws
    0
  end

  def matches
    Match.by_player(self)
  end

  def matches_played
    match_wins + match_losses
  end

  def calculate_matches_played
    matches.size
  end

  def matches_won_with(teammate)
    matches_played_with(teammate).select { |g| g.is_winning_player?(self) }
  end

  def matches_lost_with(teammate)
    matches_played_with(teammate).select { |g| g.is_losing_player?(self) }
  end

  def matches_played_with(teammate)
    Match.by_player_teammate(self, teammate)
  end

  def games
    Game.includes(:match).by_player(self)
  end

  def games_played
    game_wins + game_losses
  end

  def calculate_games_played
    games.size
  end

  def calculate_game_wins
    Game.by_winning_player(self).size
  end

  def calculate_game_losses
    Game.by_losing_player(self).size
  end

  def self.by_games_won_against(player)
    self.by_no_zeros.inject([]) { |arr,p| 
      arr << {player: p, games: player.games_won_against(p).size} unless p.id == player.id
      arr
    }.sort {|a,b| b[:games] <=> a[:games] }
  end

  def games_won_against(opponent)
    games_played_against(opponent).select { |g| g.is_winning_player?(self) }
  end

  def self.by_games_lost_against(player)
    self.by_no_zeros.inject([]) { |arr,p| 
      arr << {player: p, games: player.games_lost_against(p).size} unless p.id == player.id
      arr
    }.sort {|a,b| b[:games] <=> a[:games] }
  end

  def games_lost_against(opponent)
    games_played_against(opponent).select { |g| g.is_losing_player?(self) }
  end

  def self.by_games_played_against(player)
    self.by_no_zeros.inject([]) { |arr,p| 
      arr << {player: p, games: player.games_played_against(p).size} unless p.id == player.id
      arr
    }.sort {|a,b| b[:games] <=> a[:games] }
  end

  def games_played_against(opponent)
    Game.by_player_opponent(self, opponent)
  end

  def self.by_games_played_against(player)
    self.by_no_zeros.inject([]) { |arr,p|
      arr << {player: p, games: player.games_played_against(p).size} unless p.id == player.id
      arr
    }.sort {|a,b| b[:games] <=> a[:games] }
  end

  def games_won_with(teammate)
    games_played_with(teammate).select { |g| g.is_winning_player?(self) }
  end

  def self.by_games_won_with(player)
    self.by_no_zeros.inject([]) { |arr,p| 
      arr << {player: p, games: player.games_won_with(p).size} unless p.id == player.id
      arr
    }.sort {|a,b| b[:games] <=> a[:games] }
  end

  def games_lost_with(teammate)
    games_played_with(teammate).select { |g| g.is_losing_player?(self) }
  end

  def self.by_games_lost_with(player)
    buffer = self.by_no_zeros.inject([]) { |arr,p| 
      arr << {player: p, games: player.games_lost_with(p).size} 
      arr
    }.sort {|a,b| b[:games] <=> a[:games] }
  end

  def games_played_with(teammate)
    Game.by_player_teammate(self, teammate)
  end

  def self.by_games_played_with(player)
    self.by_no_zeros.inject([]) { |arr,p| 
      arr << {player: p, games: player.games_played_with(p).size} unless p.id == player.id
      arr 
    }.sort {|a,b| b[:games] <=> a[:games] }
  end

  def select_top_players_by_games(players, game_count)
    players.inject([]) do |arr, p| 
      arr << p[:player] if p[:games] == game_count
      arr
    end
  end

  def best_buddy
    pl = Player.by_games_played_with(self)
    max_games = pl.first[:games] unless pl.empty?
    if max_games && max_games > 0
      players = select_top_players_by_games(pl, max_games)
      players.sort { |a, b| a.games_won_with(self).size <=> b.games_won_with(self).size }.first
    end
  end

  def dynamic_duo
    pl = Player.by_games_won_with(self)
    max_games = pl.first[:games] unless pl.empty?
    if max_games && max_games > 0
      players = select_top_players_by_games(pl, max_games)
      players.sort { |a, b| a.games_played_with(self).size <=> b.games_played_with(self).size }.first
    end
  end

  def ball_and_chain
    pl = Player.by_games_lost_with(self)
    max_games = pl.first[:games] unless pl.empty?
    if max_games && max_games > 0
      players = select_top_players_by_games(pl, max_games)
      players.sort { |a, b| a.games_played_with(self).size <=> b.games_played_with(self).size }.first
      players.first
    end
  end

  def nemesis
    pl = Player.by_games_lost_against(self)
    max_games = pl.first[:games] unless pl.empty?
    if max_games && max_games > 0
      players = select_top_players_by_games(pl, max_games)
      players.sort { |a, b| a.games_played_against(self).size <=> b.games_played_against(self).size }.first
      players.first
    end
  end

  def rival
    pl = Player.by_games_played_against(self)
    max_games = pl.first[:games] unless pl.empty?
    if max_games && max_games > 0
      players = select_top_players_by_games(pl, max_games)
      players.sort { |a, b| (self.trueskill - a.trueskill).abs <=> (self.trueskill - b.trueskill).abs }.first
      players.first
    end
  end

  def punching_bag
    pl = Player.by_games_won_against(self)
    max_games = pl.first[:games] unless pl.empty?
    if max_games && max_games > 0
      players = select_top_players_by_games(pl, max_games)
      players.sort { |a, b| a.games_played_against(self).size <=> b.games_played_against(self).size }.first
      players.first
    end
  end

  def ranking(no_zeros=false)
    prs = Player.ranking_groups(no_zeros)
    pos = 1
    prs.each_with_index do |(k, v), i|
      if trueskill == k
        return pos
      else
        pos += v
      end
    end
    pos
  end

  def is_zero?
    games_played == 0 && matches_played == 0
  end

  def self.ranking_groups(no_zeros=false)
    players = no_zeros ? Player.by_no_zeros : Player.includes(:player_ratings).all
    prs = players.map { |p| p.trueskill }.sort.reverse
    prs.inject(Hash.new(0)) { |total, e| total[e] += 1 ; total}
  end

  def player_rating
    return player_ratings.first unless player_ratings.empty?
    pr = PlayerRating.new({player_id: self.id})
    pr.save
    pr.reload
  end

  def player_rating_value
    player_rating.value
  end

  def player_rating_trend
    return player_rating_trend_diff > 0 ? 1 : (player_rating_trend_diff < 0 ? -1 : 0)
  end

  def player_rating_trend_diff
    recent = matches.first
    previous = matches.second
    if recent && previous
      recent_game = recent.games.last
      prev_game = previous.games.last
      pr1 = PlayerRating.by_game_and_player(recent_game, self).first
      pr2 = PlayerRating.by_game_and_player(prev_game, self).first
    elsif recent && !previous
      recent_game = recent.games.last
      pr1 = PlayerRating.by_game_and_player(recent_game, self).first
      pr2 = player_ratings.last
    end

    return (pr1 && pr2) ? pr1.value.mean - pr2.value.mean : 0
  end

  def update_player_rating(game, mean, deviation, activity)
    if game.is_winning_player?(self)
      self.update_attributes({game_wins: game_wins+1})
    else
      self.update_attributes({game_losses: game_losses+1})
    end
    pr = PlayerRating.new({player_id: self.id, game_id: game.id, mean: mean, deviation: deviation, activity: activity})
    pr.save
  end

  def update_player_match_rating(match)
    if match.is_winning_player?(self)
      self.update_attributes({match_wins: match_wins+1})
    else
      self.update_attributes({match_losses: match_losses+1})
    end
  end
end
