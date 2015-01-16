class WelcomeController < ApplicationController
  def index
    @players = Player.includes(:teams).by_trueskill
    @matches = Match.includes(:games, :teams).all
  end
end
