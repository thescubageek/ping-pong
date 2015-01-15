module ApplicationHelper

  def get_header(str="")
    "<h1>#{home_link}#{"&nbsp;-&nbsp;#{str}" unless str.blank?}</h1>".html_safe
  end

  def home_link
    link_to('Ping Pong TrueSkill Rankings', '/')
  end

  ##
  # Returns add new action button
  #
  # @param   type    {string}     item type to create
  # @return          {string}     Add New button HTML
  ##
  def add_new_button(type)
    link_to("Add New #{type}", "/#{type.underscore}/new", {class: 'button btn-new fi-plus', data: {id: 0, type: type.underscore, action: 'new'}})
  end

  def edit_button(type, item)
    link_to("Edit", "#{item.id}/edit", {class: 'button btn-edit fi-pencil', data: {id: item.id, type: type.underscore, action: 'edit'}})
  end
end
