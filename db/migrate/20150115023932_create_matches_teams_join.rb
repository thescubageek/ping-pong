class CreateMatchesTeamsJoin < ActiveRecord::Migration
  def self.up
    create_table 'matches_teams', :id => false do |t|
      t.column 'match_id', :integer
      t.column 'team_id', :integer
    end
  end

  def self.down
    drop_table 'matches_teams'
  end
end
