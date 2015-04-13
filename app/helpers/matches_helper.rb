require 'slack-notifier'

module MatchesHelper
  def slack_message(match)
    SlackMessager.new(match).slack_message
  end

  def slack_challenge_message(match, params)
    if params[:challenge]
      p1 = Player.find(params[:p1])
      p2 = Player.find(params[:p2])
      SlackMessager.new(match).slack_challenge_message(p1, p2) if p1 && p2
    end
  end

  class SlackMessager
    attr_accessor :match

    def initialize(match)
      @match = match
    end

    def slack_message
      the_winner = match.winner
      the_loser = match.loser
      winner_name = the_winner.name
      winner_rank = the_winner.ranking(true)
      loser_name = the_loser.name
      loser_rank = the_loser.ranking(true)
      
      match_result = (match.games.count == 3) ? "*2* to *1*" : "*2* to *0*"
      game_results = [game_1.score, game_2.score]
      game_results << game_3.score if game_3
      match_message = "*##{winner_rank} #{winner_name}* has defeated *##{loser_rank} #{loser_name}* #{match_result}"

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

    def slack_challenge_message(p1, p2)
      challenge_message = "*##{p1.ranking(true)} #{p1.name}* has CHALLENGED *##{p2.ranking(true)} #{p2.name}*! See you in the Ping Pong Room!"
      attachment = {
        fallback: "",
        pretext: "",
        color: "#0000d0",
        fields: [
          {
            title: "Match Challenge",
            value: challenge_message,
            short: false
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
      if match.winner == game.winner
        "*#{game.score.max}*"
      else
        game.score.min
      end
    end

    def match_loser_presenter(game)
      if match.loser == game.loser
        game.score.min
      else
        "*#{game.score.max}*"
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
