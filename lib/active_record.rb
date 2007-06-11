module ActiveRecord #:nodoc:
  class Base
    class << self
      def attr_locked(*attributes)
        write_inheritable_array("attr_locked", attributes - (locked_attributes || []))
        define_locked_write_methods
      end
      
      def locked_attributes
        (table_read_only? ? self.new.attribute_names :
            read_inheritable_attribute("attr_locked")).to_a.collect(&:to_s)
      end
      
      def define_locked_write_methods
        locked_attributes.each do |attr|
          define_method("#{attr}=") do |value|
            write_attribute(attr, value) if !attribute_locked?(attr)
          end
        end
      end
      
      def has_locked_attribute?(attr_name)
        locked_attributes.include?(attr_name.to_s)
      end
      
      def table_locked
        write_inheritable_attribute("read_only_table", true)
        define_locked_write_methods
        def self.delete_all; return false; end
      end
      
      def table_read_only?
        read_inheritable_attribute("read_only_table") ? true : false
      end
    end
    
    def attribute_locked?(attr_name)
      self.class.table_read_only? or
          (self.class.has_locked_attribute?(attr_name) and !new_record?)
    end
    
    define_method('[]=_with_attribute_locking') do |attr_name, value|
      write_attribute(attr_name, value) if !attribute_locked?(attr_name)
    end
    alias_method('[]=_without_attribute_locking', '[]=')
    alias_method('[]=', '[]=_with_attribute_locking')
    
    def update_attribute_with_attribute_locking(name, value)
      if attribute_locked?(name)
        return false
      else
        update_attribute_without_attribute_locking(name, value)
      end
    end
    alias_method(:update_attribute_without_attribute_locking, :update_attribute)
    alias_method(:update_attribute, :update_attribute_with_attribute_locking)
    
    before_save :check_table_lock
    before_destroy :check_table_lock
    def check_table_lock
      return false if self.class.table_read_only?
    end
    
  end
end
