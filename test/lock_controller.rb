require RAILS_ROOT + '/vendor/plugins/attr_locked/test/lock'

class LockController < ApplicationController
  def index
    Lock.delete_all
    Lock.create(:name => "Bob", :description => "The testing guy", :date => "2007-06-01", :flag => true, :unlocked => "blah")
    @lock = Lock.find(:first)
  end
end
