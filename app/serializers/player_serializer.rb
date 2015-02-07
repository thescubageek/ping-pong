class PlayerSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :match_wins, :match_losses, :game_wins, 
    :game_losses, :trueskill, :best_buddy_id, :dynamic_duo_id, :ball_and_chain_id, :rival_id,
    :punching_bag_id, :nemesis_id, :player_rating_trend
end
