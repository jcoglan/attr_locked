require RAILS_ROOT + '/config/environment'

class AttrLockedMigration < ActiveRecord::Migration
  def self.up
    create_table :attr_locked_test do |t|
      t.column :name, :string, :null => true
      t.column :description, :text, :null => true
      t.column :date, :date, :null => true
      t.column :flag, :boolean, :null => true
      t.column :unlocked, :string, :null => true
    end
  end
  
  def self.down
    drop_table :attr_locked_test
  end
end
