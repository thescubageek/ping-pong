class MatchSerializer < ActiveModel::Serializer
  attributes :id, :team_1_id, :team_2_id, :date, :team_1_player_1_id, :team_1_player_2_id, 
    :team_2_player_1_id, :team_2_player_2_id
end
