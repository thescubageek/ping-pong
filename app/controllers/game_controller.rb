class GameController < ApplicationController
  def index
    @games = Game.all
  end

  def show
    @game = Game.find(params[:id])
  end

  def create
    @game = Game.new(params)
    @game.save
  end

  def update
    @game = Game.find(params[:id])
    @game.update_attributes(params) if @game
  end

  def destroy
    @game = Game.find(params[:id])
    @game.destroy if @game
  end

  private

  def game_params
    params.require(:game).permit()
  end
end
