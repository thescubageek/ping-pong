module PlayerHelper
  def players_link(options={})
    link_to('Players', {action: 'index', controller: 'player'}, options)
  end  

  def player_link(player)
    link_to(player, {class: 'player-link'}) { "#{avatar_thumbnail(player)}#{player.name}".html_safe } if player
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

  def player_trend_icon(player)
    rating_trend = player ? player.player_rating_trend : 0
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

  def match_record(player)
    "#{player.wins} - #{player.losses}".html_safe
  end

  def game_record(player)
    "#{player.game_wins} - #{player.game_losses}".html_safe
  end

  def player_select(player_pos, player_list=nil)
    player_list ||= Player.all.reverse
    opts = player_list.inject("") do |buffer, p|
      ranking = p.is_zero? ? '--' : "##{p.ranking(true)}"
      selected = (@match.send(player_pos).try(:id) == p.id) ? "selected='selected'" : ""
      buffer << "<option value='#{p.id}'#{selected}>#{ranking} #{p.name}</option>"
      buffer
    end
    opts.prepend("<option value=''>[SELECT A PLAYER]</option>")
    %Q(<select id="#{player_pos}" name="match[#{player_pos}]">#{opts}</select>).html_safe
  end
end
