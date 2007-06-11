require 'test/unit'
require File.dirname(__FILE__) + '/../../../../config/environment'
require File.dirname(__FILE__) + '/../init'
require File.dirname(__FILE__) + '/lock'
require File.dirname(__FILE__) + '/table_lock'
require File.dirname(__FILE__) + '/unlocked'

class AttrLockedTest < Test::Unit::TestCase
  
  Data = {
    :name => "Bob",
    :description => "He's the guy doing our tests",
    :date => Date.new(2007, 6, 1),
    :flag => true,
    :unlocked => "Free and easy"
  }
  
  def setup
    Lock.delete_all
    Lock.create(AttrLockedTest::Data)
    @lock = Lock.find(:first)
    @table_lock = TableLock.find(:first)
    @unlocked = Unlocked.new
  end
  
  def check_values
    assert_equal AttrLockedTest::Data[:name], @lock.name
    assert_equal AttrLockedTest::Data[:description], @lock.description
    assert_equal AttrLockedTest::Data[:date], @lock.date
    assert_equal AttrLockedTest::Data[:flag], @lock.flag
  end
  
  def test_assignment_of_single_attributes_on_new_record
    @lock = Lock.new
    assert_equal nil, @lock.name
    @lock.name = AttrLockedTest::Data[:name]
    @lock.description = AttrLockedTest::Data[:description]
    @lock.date = AttrLockedTest::Data[:date]
    @lock.flag = AttrLockedTest::Data[:flag]
    check_values
    @lock.unlocked = "all change"
    assert_equal "all change", @lock.unlocked
  end
  
  def test_assignment_of_single_attributes_by_symbol_on_new_record
    @lock = Lock.new
    assert_equal nil, @lock.name
    @lock[:name] = AttrLockedTest::Data[:name]
    @lock[:description] = AttrLockedTest::Data[:description]
    @lock[:date] = AttrLockedTest::Data[:date]
    @lock[:flag] = AttrLockedTest::Data[:flag]
    check_values
    @lock[:unlocked] = "all change"
    assert_equal "all change", @lock.unlocked
  end
  
  def test_mass_assignment_on_new_record
    @lock = Lock.new
    @lock.attributes = AttrLockedTest::Data
    check_values
  end
  
  def test_assignment_of_single_attributes_without_saving
    @lock.name = "Mike"
    @lock.description = "He's Bob's sidekick"
    @lock.date = Date.new(2005, 10, 13)
    @lock.flag = false
    check_values
    @lock.unlocked = "all change"
    assert_equal "all change", @lock.unlocked
  end
  
  def test_assignment_of_single_attributes_by_symbol_without_saving
    @lock[:name] = "Mike"
    @lock[:description] = "He's Bob's sidekick"
    @lock[:date] = Date.new(2005, 10, 13)
    @lock[:flag] = false
    check_values
    @lock[:unlocked] = "all change"
    assert_equal "all change", @lock.unlocked
  end
  
  def test_mass_assignment_without_saving
    @lock.attributes = {:name => "Mike", :description => "Just some guy",
        :date => Date.new(1979, 4, 23), :flag => false}
    check_values
  end
  
  def test_update_attributes
    @lock.update_attributes(:name => "Mike", :description => "Just some guy",
        :date => Date.new(1979, 4, 23), :flag => false, :unlocked => "anything, really")
    @lock.reload
    check_values
    assert_equal "anything, really", @lock.unlocked
  end
  
  def test_update_attribute
    assert !@lock.update_attribute(:name, "Mike")
    @lock.reload
    check_values
  end
  
  def test_assignment_on_new_locked_table_record
    @table_lock = TableLock.new
    @table_lock.unlocked = "Mike"
    assert_equal nil, @table_lock.unlocked
    @table_lock[:unlocked] = "Mike"
    assert_equal nil, @table_lock.unlocked
    @table_lock.attributes = {:unlocked => "Mike"}
    assert_equal nil, @table_lock.unlocked
  end
  
  def test_saving_on_locked_table
    @table_lock = TableLock.new(:name => "locked up")
    assert @table_lock.valid?
    assert !@table_lock.save
    @found_table_lock = TableLock.find_by_name("locked up")
    assert_equal nil, @found_table_lock
    assert_equal 1, TableLock.count
  end
  
  def test_creation_on_locked_table
    TableLock.create(:name => "locked up")
    @found_table_lock = TableLock.find_by_name("locked up")
    assert_equal nil, @found_table_lock
    assert_equal 1, TableLock.count
  end
  
  def test_updating_on_locked_table
    assert_equal AttrLockedTest::Data[:name], @table_lock.name
    assert !@table_lock.update_attribute(:unlocked, "anything")
    assert !@table_lock.update_attributes(:description => "a locked table")
    @found_table_lock = TableLock.find_by_unlocked("anything")
    assert_equal nil, @found_table_lock
    @found_table_lock = TableLock.find_by_description("a locked table")
    assert_equal nil, @found_table_lock
  end
  
  def test_destruction_on_locked_table
    assert !@table_lock.destroy
    assert_equal 1, TableLock.count
    TableLock.destroy_all
    assert_equal 1, TableLock.count
    assert !TableLock.delete_all
    assert_equal 1, TableLock.count
  end
  
  def test_operations_on_unlocked_model
    Unlocked.delete_all
    @unlocked.attributes = AttrLockedTest::Data
    assert @unlocked.save
    @unlocked = Unlocked.find(:first)
    @unlocked.update_attributes(:name => "Joe", :date => "2012-06-21")
    @unlocked.reload
    assert_equal "Joe", @unlocked.name
    assert_equal Date.new(2012, 6, 21), @unlocked.date
    @unlocked.destroy
    assert_equal 0, Unlocked.count
  end
end
