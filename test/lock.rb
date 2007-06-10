class Lock < ActiveRecord::Base
  set_table_name 'attr_locked_test'
  attr_locked :name, :description, :date, :flag
end
