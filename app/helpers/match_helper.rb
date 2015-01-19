module MatchHelper
  def matches_link(options={})
    link_to('Matches', {action: 'index', controller: 'match'}, options)
  end
end
