module ApplicationHelper

  def get_header(str="")
    links = "<div class='links'>#{players_link}#{matches_link}</div>"
    h1 = "<h1>#{home_link}#{"&nbsp;-&nbsp;#{str}" unless str.blank?}</h1>"
    "<header>#{h1}#{links}</header>".html_safe
  end

  def add_new_button(type)
    link_to("Add New #{type}", "/#{type.underscore}/new", {class: 'button btn-new fi-plus', data: {id: 0, type: type.underscore, action: 'new'}})
  end

  def edit_button(type, item)
    link_to("Edit", "#{item.id}/edit", {class: 'button btn-edit fi-pencil', data: {id: item.id, type: type.underscore, action: 'edit'}})
  end

  def cancel_button(type)
    link_to('Cancel', {action: 'index', controller: type}, {class: 'btn-cancel'})
  end

  def player_trend_icon(player)
    rating_trend = player ? player.player_rating_trend : 0
    (rating_trend > 0 ? up_trend_arrow : (rating_trend < 0 ? down_trend_arrow : "")).html_safe
  end

  def up_trend_arrow
    "<span class='btn-arrow-up-green'></span>"
  end

  def down_trend_arrow
    "<span class='btn-arrow-down-red'></span>"
  end

  def home_link(options={})
    link_to('G5 Ping Pong Rankings', '/', options)
  end

  def players_link(options={})
    link_to('Players', {action: 'index', controller: 'player'}, options)
  end

  def matches_link(options={})
    link_to('Matches', {action: 'index', controller: 'match'}, options)
  end
end
