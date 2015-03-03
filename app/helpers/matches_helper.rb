require 'slack-notifier'

module MatchesHelper
  def slack_message(match)
    winner_name = match.winner[0].name
    loser_name = match.loser[0].name
    match_result = (match.games.count == 3) ? "2 games to 1" : "2 games to 0"
    game_results = [match.game_1.score, match.game_2.score]
    game_results << match.game_3.score if match.game_3
    match_message = "#{winner_name} has defeated #{loser_name} #{match_result} (#{game_results.join(', ')})"

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
    
    if ENV["SLACK_TOKEN"]
      slack = Slack::Notifier.new "https://hooks.slack.com/services/#{ENV["SLACK_TOKEN"]}", channel: '#g5_pingpong', username: 'PingBot'
      slack.ping("", attachments: [attachment])
    end
  end
end