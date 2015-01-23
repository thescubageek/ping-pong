class WelcomeController < ApplicationController
  def index
    @players = Player.by_trueskill
    @matches = Match.all.take(10)
  end
end
