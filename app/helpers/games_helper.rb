module GamesHelper
  def game_score(game)
    "#{game.score_1} - #{game.score_2}" if game
  end
end
