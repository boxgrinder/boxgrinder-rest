class CreateNodes < ActiveRecord::Migration
  def self.up
    create_table :nodes do |t|
      t.string :name, :limit => 100, :null => false
      t.string :state, :limit => 20, :null => false
      t.string :address, :limit => 30, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :nodes
  end
end
