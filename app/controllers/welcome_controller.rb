class WelcomeController < ApplicationController
  def index
    @players = Player.all.by_trueskill
    @matches = Match.all
  end
end
