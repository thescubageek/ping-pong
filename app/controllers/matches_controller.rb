class MatchesController < ApplicationController
  include MatchesHelper

  def index
    respond_to do |format|
      format.html { @matches = Match.includes(:players).all }
      format.json { render json: Match.includes(:players).all }
    end
  end

  def show
    @match = Match.includes(:players).find(params[:id])
  end

  def new
    @match = Match.new
    @player_list = Player.all.reverse
  end

  def edit
    @match = Match.find(params[:id])
    @player_list = Player.all.reverse
  end

  def create
    unless match_params[:team_1_player_1].blank? || match_params[:team_2_player_1].blank?
      find_team_players
      create_new_games
      create_new_match
    end
    redirect_to action: 'index', controller: 'welcome'
  end

  def update
    @match = Match.find(params[:id])
    unless @match.blank? || match_params[:team_1_player_1].blank? || match_params[:team_2_player_1].blank?
      find_team_players
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
    if !match_params[:game_1_score_1].blank? && !match_params[:game_1_score_2].blank?
      @game_1 = Game.new(score_1: match_params[:game_1_score_1], score_2: match_params[:game_1_score_2])
    end
    if !match_params[:game_2_score_1].blank? && !match_params[:game_2_score_2].blank?
      @game_2 = Game.new(score_1: match_params[:game_2_score_1], score_2: match_params[:game_2_score_2])
    end
    if !match_params[:game_3_score_1].blank? && !match_params[:game_3_score_2].blank?
      @game_3 = Game.new(score_1: match_params[:game_3_score_1], score_2: match_params[:game_3_score_2])
    end
  end

  def create_new_match
    players = find_team_players
    player_ids = players.map(&:id)
    @match = Match.new({
      team_1_player_1_id: @team_1_player_1.try(:id),
      team_1_player_2_id: @team_1_player_2.try(:id),
      team_2_player_1_id: @team_2_player_1.try(:id),
      team_2_player_2_id: @team_2_player_2.try(:id)
    })
    @match.date = Time.now()
    @match.player_ids = player_ids
    @match.games = @game_3 ? [@game_1, @game_2, @game_3] : [@game_1, @game_2]
    @match.save
    @game_1.update_attributes(match_id: @match.id) if @game_1
    @game_2.update_attributes(match_id: @match.id) if @game_2
    @game_3.update_attributes(match_id: @match.id) if @game_3
    @match.update_player_rankings
<<<<<<< HEAD
    slack_message(@match)
=======
    winner_name = "#{@match.winner[0].first_name}" + " #{@match.winner[0].last_name} "
    loser_name = "#{@match.loser[0].first_name}" + " #{@match.loser[0].last_name} "
    if @match.games.count == 3
      match_message = winner_name + " has defeated " + loser_name + "2 games to 1!"
    else
      match_message = winner_name + " has defeated " + loser_name + "2 games to 0!"
    end
    attachment = {
      fallback: "Match Complete",
      pretext: "Match Complete",
      color: "#0000d0",
      fields: [
        {
          title: "Match Results",
          value: match_message,
          short: false
        }
      ]
    }

    slack = Slack::Notifier.new "https://hooks.slack.com/services/#{ENV["SLACK_TOKEN"]}", channel: '#g5_pingpong', username: 'PingBot'
    slack.ping("", attachments: [attachment])
>>>>>>> 62fe275fd4c03575ad47a4234e10931d3acee76b
  end

  def update_games
    @match.game_1.update_attributes(score_1: match_params[:game_1_score_1], score_2: match_params[:game_1_score_2])
    @match.game_2.update_attributes(score_1: match_params[:game_2_score_1], score_2: match_params[:game_2_score_2])
    @game_1 = @match.reload.game_1
    @game_2 = @match.reload.game_2
    if !match_params[:game_3_score_1].blank? && !match_params[:game_3_score_2].blank?
      if @match.game_3
        @match.game_3.update_attributes(score_1: match_params[:game_3_score_1], score_2: match_params[:game_3_score_2])
        @game_3 = @match.reload.game_3
      else
        @game_3 = Game.new(score_1: match_params[:game_3_score_1], score_2: match_params[:game_3_score_2], match_id: @match.id, date: @match.date)
        @game_3.save
      end
    elsif @match.game_3
      @match.game_3.destroy
      @game_3 = nil
    end
  end

  def update_match
    @match.games = @game_3 ? [@game_1, @game_2, @game_3] : [@game_1, @game_2]
    @game_1.update_attributes(match_id: @match.id) if @game_1
    @game_2.update_attributes(match_id: @match.id) if @game_2
    @game_3.update_attributes(match_id: @match.id) if @game_3
    find_team_players
    @match.update_attributes({
      team_1_player_1_id: @team_1_player_1.try(:id),
      team_1_player_2_id: @team_1_player_2.try(:id),
      team_2_player_1_id: @team_2_player_1.try(:id),
      team_2_player_2_id: @team_2_player_2.try(:id)
    })
    @match.player_ids = @match.get_player_ids
    @match.save
    RankingUpdater.update(@match.id)
  end

  def find_team_players
    @team_1_player_1 = Player.find_by_id(match_params[:team_1_player_1])
    @team_1_player_2 = Player.find_by_id(match_params[:team_1_player_2])
    @team_2_player_1 = Player.find_by_id(match_params[:team_2_player_1])
    @team_2_player_2 = Player.find_by_id(match_params[:team_2_player_2])
    (@team_1_player_2 && @team_2_player_2) ? [@team_1_player_1, @team_1_player_2, @team_2_player_1, @team_2_player_2] : [@team_1_player_1, @team_2_player_1]
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

