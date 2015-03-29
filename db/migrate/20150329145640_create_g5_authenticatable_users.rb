class CreateG5AuthenticatableUsers < ActiveRecord::Migration
  def change
    create_table(:g5_authenticatable_users) do |t|
      # G5 authenticatable
      t.string :email,              null: false, default: ''
      t.string :provider,           null: false, default: 'g5'
      t.string :uid,                null: false
      t.string :g5_access_token

      # Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.timestamps
    end

    add_index :g5_authenticatable_users, :email, unique: true
    add_index :g5_authenticatable_users, [:provider, :uid], unique: true
  end
end
