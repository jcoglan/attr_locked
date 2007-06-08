module ActiveRecord #:nodoc:
  class Base
    class << self
      def attr_locked(*attributes)
        write_inheritable_array("attr_locked", attributes - (locked_attributes || []))
        define_locked_write_methods
      end
      
      def locked_attributes
        read_inheritable_attribute("attr_locked")
      end
      
      def define_locked_write_methods
        locked_attributes.to_a.collect(&:to_s).each do |attr|
          define_method("#{attr}=") do |value|
            @attributes[attr] = value if new_record?
          end
        end
      end
    end
    
    def update_attribute_with_attribute_locking(name, value)
      if self.class.locked_attributes.to_a.collect(&:to_s).include?(name.to_s)
        return false
      else
        update_attribute_without_attribute_locking(name, value)
      end
    end
    alias_method(:update_attribute_without_attribute_locking, :update_attribute)
    alias_method(:update_attribute, :update_attribute_with_attribute_locking)
  end
end
