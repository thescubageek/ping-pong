module ApplicationHelper

  def get_header(str="")
    links = "<div class='links'>#{players_path}#{link_to "Matches", matches_path}</div>"
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
end
