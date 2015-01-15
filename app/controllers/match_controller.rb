class MatchController < ApplicationController
  def index
    @matches = Match.all
  end

  def show
    @match = Match.find(params[:id])
  end

  def new
    @match = Match.new
  end

  def edit
    @match = Match.find(params[:id])
  end

  def create
    if create_new_teams
      create_new_games
      create_new_match
    end
    redirect_to action: 'index', controller: 'welcome'
  end

  def update
    @match = Match.find(params[:id])
    if update_teams
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

  private

  def create_new_teams
    unless match_params[:team_1_player_1].blank? || match_params[:team_2_player_1].blank?
      @team_1 = Team.new(player_1_id: match_params[:team_1_player_1], player_2_id: match_params[:team_1_player_2])
      @team_2 = Team.new(player_1_id: match_params[:team_2_player_1], player_2_id: match_params[:team_2_player_2])
      find_team_players
      @team_1.players = @team_1_player_2 ? [@team_1_player_1, @team_1_player_2] : [@team_1_player_1]
      @team_2.players = @team_2_player_2 ? [@team_2_player_1, @team_2_player_2] : [@team_2_player_1]
      @team_1.save
      @team_2.save
      return true
    end
    false
  end

  def create_new_games
    @game_1 = Game.new(score_1: match_params[:game_1_score_1], score_2: match_params[:game_1_score_2])
    @game_2 = Game.new(score_1: match_params[:game_2_score_1], score_2: match_params[:game_2_score_2])
    if !match_params[:game_3_score_1].blank? && !match_params[:game_3_score_2].blank?
      @game_3 = Game.new(score_1: match_params[:game_3_score_1], score_2: match_params[:game_3_score_2])
    end
  end

  def create_new_match
    @match = Match.new
    @match.games = @game_3 ? [@game_1, @game_2, @game_3] : [@game_1, @game_2]
    @match.teams = [@team_1, @team_2]
    @match.team_1_id = @team_1.id
    @match.team_2_id = @team_2.id
    @match.date = Time.now()
    @match.save
    @game_1.update_attributes(match_id: @match.id)
    @game_2.update_attributes(match_id: @match.id)
    @game_3.update_attributes(match_id: @match.id) if @game_3
  end

  def update_teams
      unless match_params[:team_1_player_1].blank? || match_params[:team_2_player_1].blank?
      @team_1 = @match.team_1.update_attributes(player_1_id: match_params[:team_1_player_1], player_2_id: match_params[:team_1_player_2])
      @team_2 = @match.team_2.update_attributes(player_1_id: match_params[:team_2_player_1], player_2_id: match_params[:team_2_player_2])
      find_team_players
      @team_1.players = @team_1_player_2 ? [@team_1_player_1, @team_1_player_2] : [@team_1_player_1]
      @team_2.players = @team_2_player_2 ? [@team_2_player_1, @team_2_player_2] : [@team_2_player_1]
      @team_1.reload
      @team_2.reload
      return true
    end
    false
  end

  def update_games
    @game_1 = @match.game_1.update_attributes(score_1: match_params[:game_1_score_1], score_2: match_params[:game_1_score_2])
    @game_2 = @match.game_2.update_attributes(score_1: match_params[:game_2_score_1], score_2: match_params[:game_2_score_2])
    if !match_params[:game_3_score_1].blank? && !match_params[:game_3_score_2].blank?
      if @match.game_3
        @game_3 = @match.game_3.update_attributes(score_1: match_params[:game_3_score_1], score_2: match_params[:game_3_score_2])
      else
        @game_3 = Game.new(score_1: match_params[:game_3_score_1], score_2: match_params[:game_3_score_2])
        @match.game_3 = @game_3
      end
    elsif @match.game_3
      @match.game_3.destroy
    end
  end

  def update_match
    @match.games = @game_3 ? [@game_1, @game_2, @game_3] : [@game_1, @game_2]
    @match.teams = [@team_1, @team_2]
    @match.update_attributes(team_1_id: @team_1.id, team_2_id: @team_2.id)
    @game_1.update_attributes(match_id: @match.id)
    @game_2.update_attributes(match_id: @match.id)
    @game_3.update_attributes(match_id: @match.id) if @game_3
    @match.reload
  end

  def find_team_players
    @team_1_player_1 = Player.find_by_id(match_params[:team_1_player_1])
    @team_1_player_2 = Player.find_by_id(match_params[:team_1_player_2])
    @team_2_player_1 = Player.find_by_id(match_params[:team_2_player_1])
    @team_2_player_2 = Player.find_by_id(match_params[:team_2_player_2])
  end

  def match_params
    params.require(:match).permit(:team_1_player_1, 
                                  :team_1_player_2, 
                                  :team_2_player_1,
                                  :team_2_player_2,
                                  :game_1_score_1,
                                  :game_1_score_2,
                                  :game_2_score_1,
                                  :game_2_score_2,
                                  :game_3_score_1,
                                  :game_3_score_2)
  end
end

