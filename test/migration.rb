require RAILS_ROOT + '/config/environment'

class AttrLockedMigration < ActiveRecord::Migration
  def self.up
    create_table :attr_locked_test do |t|
      t.column :name, :string
      t.column :description, :text
      t.column :date, :date
      t.column :flag, :boolean
      t.column :unlocked, :string
    end
  end
  
  def self.down
    drop_table :attr_locked_test
  end
end
