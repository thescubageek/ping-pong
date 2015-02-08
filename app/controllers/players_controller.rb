class PlayersController < ApplicationController
  def index
    respond_to do |format|
      format.html { @players = Player.by_trueskill }
      format.json do
        if params[:no_zeros] == 'true'
          render json: Player.no_zeros.by_trueskill
        else
          render json: Player.by_trueskill
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
    {}
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

