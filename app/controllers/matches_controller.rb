class MatchesController < ApplicationController
  include MatchesHelper

  def index
    respond_to do |format|
      format.html { @matches = Match.all }
      format.json { render json: Match.all }
    end
  end

  def show
    @match = Match.includes(:players).find(params[:id])
  end

  def new
    @match = Match.new
    @player_list = Player.by_name
    slack_challenge_message(@match, params)
  end

  def edit
    @match = Match.find(params[:id])
    @player_list = Player.by_name
  end

  def create
    unless match_params[:player_1].blank? || match_params[:player_2].blank?
      find_players
      create_new_games
      create_new_match
    end
    redirect_to action: 'index', controller: 'welcome'
  end

  def update
    @match = Match.find(params[:id])
    unless @match.blank? || match_params[:player_1].blank? || match_params[:player_2].blank?
      find_players
      update_games
      update_match
    end
    redirect_to action: 'index', controller: 'welcome'
  end

  def destroy
    @match = Match.find(params[:id])
    @match.destroy if @match
    redirect_to action: 'index', controller: 'welcome'
  end

  def create_new_games
    players = find_players
    game_date = Time.now()
    if !match_params[:game_1_score_1].blank? && !match_params[:game_1_score_2].blank?
      @game_1 = create_new_game(@player_1.id, @player_2.id, match_params[:game_1_score_1], match_params[:game_1_score_2], game_date)
    end
    if !match_params[:game_2_score_1].blank? && !match_params[:game_2_score_2].blank?
      @game_2 = create_new_game(@player_1.id, @player_2.id, match_params[:game_2_score_1], match_params[:game_2_score_2], game_date)
    end
    if !match_params[:game_3_score_1].blank? && !match_params[:game_3_score_2].blank?
      @game_3 = create_new_game(@player_1.id, @player_2.id, match_params[:game_3_score_1], match_params[:game_3_score_2], game_date)
    end
  end

  def create_new_game(p1, p2, s1, s2, date)
    game = Game.new({ player_1_id: p1, player_2_id: p2, score_1: s1, score_2: s2, date: date})
    game.save
    game
  end

  def create_new_match
    players = find_players
    @match = Match.new({ player_1_id: @player_1.id, player_2_id: @player_2.id, date: Time.now() })
    @match.games = @game_3 ? [@game_1, @game_2, @game_3] : [@game_1, @game_2]
    @match.save
    
    @game_1.update_attributes(match_id: @match.id) if @game_1
    @game_2.update_attributes(match_id: @match.id) if @game_2
    @game_3.update_attributes(match_id: @match.id) if @game_3
    @match.update_player_rankings
    
    slack_message(@match)
  end

  def update_games
    find_players

    update_game(@match.game_1, @player_1.id, @player_2.id, match_params[:game_1_score_1], match_params[:game_1_score_2])
    @game_1 = @match.reload.game_1
    
    update_game(@match.game_2, @player_1.id, @player_2.id, match_params[:game_2_score_1], match_params[:game_2_score_2])
    @game_2 = @match.reload.game_2
    
    if !match_params[:game_3_score_1].blank? && !match_params[:game_3_score_2].blank?
      if @match.game_3
        update_game(@match.game_3, @player_1.id, @player_2.id, match_params[:game_3_score_1], match_params[:game_3_score_2])
        @game_3 = @match.reload.game_3
      else
        @game_3 = create_new_game(@player_1.id, @player_2.id, match_params[:game_3_score_1], match_params[:game_3_score_2], @match.date)
        @game_3.update_attribute(:match_id, @match.id)
      end
    elsif @match.game_3
      @match.game_3.destroy
      @game_3 = nil
    end
  end

  def update_game(game, p1, p2, s1, s2)
    game.update_attributes({
      score_1: s1,
      score_2: s2,
      player_1_id: p1,
      player_2_id: p2
    }) if game
  end

  def update_match
    @match.games = @game_3 ? [@game_1, @game_2, @game_3] : [@game_1, @game_2]
    @game_1.update_attributes(match_id: @match.id) if @game_1
    @game_2.update_attributes(match_id: @match.id) if @game_2
    @game_3.update_attributes(match_id: @match.id) if @game_3
    
    find_players
    @match.update_attributes({
      player_1_id: @player_1.id,
      player_2_id: @player_2.id
    })
    @match.player_ids = @match.get_player_ids
    @match.save
    RankingUpdater.update(@match.id)
  end

  def find_players
    @player_1 = Player.find_by_id(match_params[:player_1])
    @player_2 = Player.find_by_id(match_params[:player_2])
    [@player_1, @player_1].compact
  end

  def match_params
    params.require(:match).permit(:player_1,
                                  :player_2,
                                  :game_1_score_1,
                                  :game_1_score_2,
                                  :game_2_score_1,
                                  :game_2_score_2,
                                  :game_3_score_1,
                                  :game_3_score_2)
  end
end

