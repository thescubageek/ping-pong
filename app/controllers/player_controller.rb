class PlayerController < ApplicationController
  def index
    @players = Player.by_trueskill
  end

  def show
    @player = Player.find(params[:id])
  end

  def new
    @player = Player.new
  end

  def edit
    @player = Player.find(params[:id])
  end

  def create
    @player = Player.new(player_params)
    new_rating if @player.save
    redirect_to action: 'index', controller: 'player'
  end

  def update
    @player = Player.find(params[:id])
    @player.update_attributes(player_params) if @player
    redirect_to action: 'index', controller: 'player'
  end

  def destroy
    @player = Player.find(params[:id])
    @player.destroy if @player
    redirect_to action: 'index', controller: 'player'
  end

  private

  def new_rating
    if @player
      @rating = PlayerRating.new({player_id: @player.id, date: DateTime.new(2015,1,14)})
      @rating.save
    end
  end

  def player_params
    params.require(:player).permit(:first_name, :last_name, :email)
  end
end
