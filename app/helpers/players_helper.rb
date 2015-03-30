module PlayersHelper

  def player_link(player)
    link_to(player, {class: 'player-link'}) { "#{avatar_thumbnail(player)}#{player.name}".html_safe } if player
  end

  def player_challenge_link(player)
    link_to("Challenge!", {action: 'new', controller: 'matches', params: {p1: current_player.id, p2: player.id, challenge: true}}, {class: 'player-challenge'}) if current_player && current_player != player
  end

  def avatar_big(player)
    image_tag(avatar_url(player), class: "img_big")
  end

  def avatar_thumbnail(player)
    image_tag(avatar_url(player), class: "img_preview")
  end

  def avatar_url(player)
    gravatar_id = Digest::MD5.hexdigest(player.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=48&d=#{CGI.escape(avatar_guest_url)}"
  end

  def avatar_guest_url
    asset_url "guest.png"
  end

  def trend_icon(player, rating_type)
    rating_trend = player ? player.try("#{rating_type}_rating_trend") : 0
    get_trend_arrow(rating_trend)
  end

  def get_trend_arrow(rating_trend)
    if rating_trend && rating_trend != 0
      return (rating_trend > 0 ? up_trend_arrow : down_trend_arrow).html_safe
    end
  end

  def up_trend_arrow
    "<span class='btn-arrow-up-green'></span>"
  end

  def down_trend_arrow
    "<span class='btn-arrow-down-red'></span>"
  end

  def rating_with_trend(player, rating_type)
    r_value = player.try("#{rating_type}_rating_value")
    value = number_with_precision(r_value.is_a?(Float) ? r_value : r_value.mean)
    arrow = trend_icon(player, rating_type)
    trend = number_with_precision(player.try("#{rating_type}_rating_trend_diff"))
    link_to("#{value} <span class='trend'>#{arrow}#{trend}</span>".html_safe, player)
  end

  def match_record(player)
    "#{player.wins} - #{player.losses}".html_safe
  end

  def game_record(player)
    "#{player.game_wins} - #{player.game_losses}".html_safe
  end

  def player_select(player_pos, player_list=nil, target=nil)
    player_list ||= Player.all.reverse
    opts = player_list.inject("") do |buffer, p|
      ranking = p.is_zero? ? '--' : "##{p.ranking(true)}"
      selected = "selected='selected'" if is_player_selected?(p, player_pos, target)
      buffer << "<option value='#{p.id}'#{selected}>#{p.name} #{ranking}</option>"
      buffer
    end
    opts.prepend("<option value=''>[SELECT A PLAYER]</option>")
    %Q(<select id="#{player_pos}" name="match[#{player_pos}]">#{opts}</select>).html_safe
  end

  def is_player_selected?(player, player_pos, target)
    pos_id = @match.send(player_pos).try(:id)
    return pos_id == player.id if player && pos_id
    return target.id == player.id if player && target
    false
  end

  def current_player_title
    return unless current_player

    avatar = avatar_big(current_player)
    ranking = current_player.ranking(true)
    title = link_to("#{avatar} ##{ranking} #{current_player.name}".html_safe, current_player)
    matches = match_record(current_player)
    games = game_record(current_player)

    "#{title} (#{matches}, #{games}) #{logout_link}".html_safe
  end
end

