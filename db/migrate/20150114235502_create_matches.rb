class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.datetime :date, :null => false, :default => Time.now
    end
  end
end
