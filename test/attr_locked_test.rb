require 'test/unit'
require File.dirname(__FILE__) + '/../../../../config/environment'
require File.dirname(__FILE__) + '/../init'
require File.dirname(__FILE__) + '/lock'

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
    assert_equal false, @lock.update_attribute(:name, "Mike")
    @lock.reload
    check_values
  end
end
