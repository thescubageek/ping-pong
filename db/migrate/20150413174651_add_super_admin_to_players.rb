class AddSuperAdminToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :super_admin, :boolean, :default => false
  end
end
