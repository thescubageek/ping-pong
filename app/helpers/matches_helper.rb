require 'slack-notifier'

module MatchesHelper
  def slack_message(match)
    SlackMessager.new(match).slack_message
  end

  class SlackMessager
    attr_accessor :match

    def initialize(match)
      @match = match
    end

    def slack_message
      winner_name = match.winner[0].name
      loser_name = match.loser[0].name
      match_result = (match.games.count == 3) ? "*2* to *1*" : "*2* to *0*"
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
      channel = "#g5_pingpong" if Rails.env.production?
      channel = "#pingbottest" if Rails.env.development?
      Slack::Notifier.new "https://hooks.slack.com/services/#{ENV["SLACK_TOKEN"]}", channel: channel, username: 'PingBot'
    end

    def score_chart
      score_chart = 
      "#{match_winner_presenter(game_1)}\t#{match_loser_presenter(game_1)}\n" +
      "#{match_winner_presenter(game_2)}\t#{match_loser_presenter(game_2)}\n"
      if game_3
        score_chart.concat("#{match_winner_presenter(game_3)}\t#{match_loser_presenter(game_3)}") if game_3
      end
      score_chart
    end

    def match_winner_presenter(game)
      score_array = game.score.split(' - ').map(&:to_i)
      if match.winner == game.winner
        "*#{score_array.max}*"
      else
        score_array.min
      end
    end

    def match_loser_presenter(game)
      score_array = game.score.split(' - ').map(&:to_i)
      if match.loser == game.loser
        score_array.min
      else
        "*#{score_array.max}*"
      end
    end

    def game_1
      match.game_1
    end

    def game_2
      match.game_2
    end

    def game_3
      match.game_3
    end

    def string_surround(string, surround)
      string.prepend(surround).concat(surround)
    end

  end
end
