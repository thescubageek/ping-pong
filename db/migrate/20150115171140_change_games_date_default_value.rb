class ChangeGamesDateDefaultValue < ActiveRecord::Migration
  def change
    execute 'alter table games alter column date set default now()'
  end
end
