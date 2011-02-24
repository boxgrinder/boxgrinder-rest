class CreateAppliances < ActiveRecord::Migration
  def self.up
    create_table :appliances do |t|
      t.string :name, :limit => 100, :null => false
      t.string :state, :limit => 20, :null => false
      t.string :definition, :limit => 10000, :null => false
      t.timestamps
    end

    add_index :appliances, :name, :unique => true
  end

  def self.down
    drop_table :appliances
  end
end
