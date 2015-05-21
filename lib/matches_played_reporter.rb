class MatchesPlayerReporter
  def initialize
    @players = Player.all
  end

  def most_matches
    @players.map do |p|
      { player_name: p.name, match_count: p.matches.size, game_count: p.games.size }
    end.sort { |a, b| b[:game_count] <=>  a[:game_count] }
  end

  def most_match_wins
    @players.map do |p|
      { player_name: p.name, wins: p.matches.select { |m| m.is_winner?(p) }.size }
    end.sort { |a, b| b[:wins] <=>  a[:wins] }
  end

  def most_losses
    @players.map do |p|
      { player_name: p.name, losses: p.matches.select { |m| m.is_loser?(p) }.size }
    end.sort { |a, b| b[:losses] <=>  a[:losses] }
  end
end