class PlayersController < ApplicationController
  def index
    respond_to do |format|
      format.html { @players = Player.all.includes(:game_ratings).includes(:match_ratings) }
      format.json do
        if params[:no_zeros] == 'true'
          render json: Player.no_zeros
        elsif params[:only_zeros] == 'true'
          render json: Player.only_zeros
        else
          render json: Player.all
        end
      end
    end
  end

  def show
    player = Player.find(params[:id])
    respond_to do |format|
      format.html { @player = player }
      format.json { render json: player }
    end
  end

  def new
    @player = Player.new
  end

  def edit
    @player = Player.find(params[:id])
  end

  def options
    render json: {}
  end

  def create
    @player = Player.new(player_params)
    new_ratings if @player.save

    respond_to do |format|
      format.html do
        redirect_to action: 'index', controller: 'players'
      end
      format.json do
        render json: @player
      end
    end

  end

  def update
    @player = Player.find(params[:id])
    @player.update_attributes(player_params) if @player
    redirect_to action: 'index', controller: 'players'
  end

  def destroy
    @player = Player.find(params[:id])
    @player.destroy if @player
    redirect_to action: 'index', controller: 'players'
  end

  private

  def new_ratings
    if @player
      @game_rating = GameRating.new({player_id: @player.id, date: Match::EARLIEST_DATE})
      @game_rating.save
      @match_rating = MatchRating.new({player_id: @player.id, date: Match::EARLIEST_DATE})
      @match_rating.save
    end
  end

  def player_params
    params.require(:player).permit(:first_name, :last_name, :email)
  end
end

