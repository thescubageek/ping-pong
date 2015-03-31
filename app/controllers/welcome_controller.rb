class WelcomeController < ApplicationController
  def index
    redirect_to 'players#new' if current_user && !current_player
    @players = Player.no_zeros
    @matches = Match.includes(:players).limit(10)
  end
end
