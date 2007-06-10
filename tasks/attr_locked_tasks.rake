namespace :attr_locked do

  desc "Create attr_locked test table"
  task :migrate do
    require File.dirname(__FILE__) + '/../test/migration'
    AttrLockedMigration.up
  end
  
  desc "Drop attr_locked test table"
  task :rollback do
    require File.dirname(__FILE__) + '/../test/migration'
    AttrLockedMigration.down
  end

end
