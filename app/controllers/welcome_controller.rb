class WelcomeController < ApplicationController
  def index
    redirect_to 'players#new' if current_user && !current_player
    @players = Player.by_trueskill
    @matches = Match.includes(:players).limit(10)
  end
end
