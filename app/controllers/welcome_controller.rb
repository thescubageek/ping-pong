class WelcomeController < ApplicationController
  def index
    @players = Player.by_trueskill
    @matches = Match.limit(10)
  end
end
