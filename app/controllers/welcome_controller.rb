class WelcomeController < ApplicationController
  def index
    @players = Player.by_trueskill
    @matches = Match.includes(:players).limit(10)
  end
end
