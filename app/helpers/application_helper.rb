module ApplicationHelper

  def get_header(str="")
    links = "<div class='links'>#{link_to('Players', action: 'index', controller: 'player')}#{link_to('Matches', action: 'index', controller: 'match')}</div>"
    h1 = "<h1>#{home_link}#{"&nbsp;-&nbsp;#{str}" unless str.blank?}</h1>"
    "<header>#{h1}#{links}</header>".html_safe
  end

  def home_link
    link_to('G5 Ping Pong Rankings', '/')
  end

  def add_new_button(type)
    link_to("Add New #{type}", "/#{type.underscore}/new", {class: 'button btn-new fi-plus', data: {id: 0, type: type.underscore, action: 'new'}})
  end

  def edit_button(type, item)
    link_to("Edit", "#{item.id}/edit", {class: 'button btn-edit fi-pencil', data: {id: item.id, type: type.underscore, action: 'edit'}})
  end

  def cancel_button
    link_to('Cancel', action: 'index', controller: 'welcome')
  end

  def player_trend_icon(player)
    rating_trend = player ? player.player_rating_trend : 0
    str = rating_trend > 0 ? "<span class='btn-arrow-up-green'></span>" : (rating_trend < 0 ? "<span class='btn-arrow-down-red'></span>" : "")
    str.html_safe
  end
end
