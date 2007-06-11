require RAILS_ROOT + '/vendor/plugins/attr_locked/test/lock'
require RAILS_ROOT + '/vendor/plugins/attr_locked/test/table_lock'
require RAILS_ROOT + '/vendor/plugins/attr_locked/test/unlocked'

class LockController < ApplicationController
  def index
    Lock.delete_all
    Lock.create(:name => "Bob", :description => "The testing guy", :date => "2007-06-01", :flag => true, :unlocked => "blah")
    @lock = Lock.find(:first)
    @table_lock = TableLock.new
    @unlocked = Unlocked.find(:first)
  end
end
