require 'slack-notifier'

module MatchesHelper
  def slack_message(match)
    SlackMessager.new(match).slack_message
  end

  class SlackMessager
    def initialize(match)
      @match = match
    end

    def slack_message
      winner_name = @match.winner[0].name
      loser_name = @match.loser[0].name
      match_result = (@match.games.count == 3) ? "*2* to *1*" : "*2* to *0*"
      game_results = [game_1.score, game_2.score]
      game_results << game_3.score if game_3
      match_message = "*#{winner_name}* has defeated *#{loser_name}* #{match_result}"

      attachment = {
        fallback: "",
        pretext: "",
        color: "#0000d0",
        fields: [
          {
            title: "Match Results",
            value: match_message,
            short: false
          },
          {
            title: '',
            value: score_chart,
            short: true
          }
        ],
        mrkdwn_in: ['fields']
      }
      
      if ENV["SLACK_TOKEN"]
        slack_client.ping("", attachments: [attachment])
      end
    end

    private

    def slack_client
      Slack::Notifier.new "https://hooks.slack.com/services/#{ENV["SLACK_TOKEN"]}", channel: '#g5_pingpong', username: 'PingBot'
    end

    def score_chart
      score_chart = 
      "#{game_1.winner == @match.team_1 ? string_surround(game_1.score.split(' - ').first, "*") : game_1.score.split(' - ').first}   #{game_1.winner == @match.team_2 ? string_surround(game_1.score.split(' - ').last, "*") : game_1.score.split(' - ').last}\n" +
      "#{game_2.winner == @match.team_1 ? string_surround(game_1.score.split(' - ').first, "*") : game_2.score.split(' - ').first}   #{game_2.winner == @match.team_2 ? string_surround(game_1.score.split(' - ').last, "*") : game_1.score.split(' - ').last}\n"
      if game_3
        scorechart.concat("#{(game_3.winner == @match.team_1 ? string_surround(game_1.score.split(' - ').first, "*") : game_1.score.split(' - ').first) + (game_3.winner == @match.team_2 ? string_surround(game_1.score.split(' - ').last, "*") : game_1.score.split(' - ').last) if game_3}")
      end
      score_chart
    end

    def game_1
      @match.game_1
    end

    def game_2
      @match.game_2
    end

    def game_3
      @match.game_3
    end

    def string_surround(string, surround)
      string.prepend(surround).concat(surround)
    end

  end
end
