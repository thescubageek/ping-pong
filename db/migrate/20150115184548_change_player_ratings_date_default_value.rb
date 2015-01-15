class ChangePlayerRatingsDateDefaultValue < ActiveRecord::Migration
  def change
    execute 'alter table player_ratings alter column date set default now()'
  end
end
