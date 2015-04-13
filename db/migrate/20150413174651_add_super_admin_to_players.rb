class AddSuperAdminToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :super_admin, :boolean, :default => false

    Player.find_by_email('steve.craig@getg5.com').update_attribute(:super_admin, true)
  end
end
