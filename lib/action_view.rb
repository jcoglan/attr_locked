module ActionView #:nodoc:
  module Helpers #:nodoc:
    class InstanceTag
    
      def attribute_locked?
        object.is_a?(ActiveRecord::Base) and
            (object.class.table_read_only? or 
            (object.class.has_locked_attribute?(method_name) and
            !object.new_record?))
      end
      
      def tag_with_attribute_locking(name, options = nil)
        options = (options || {}).update("disabled" => attribute_locked?)
        tag_without_attribute_locking(name, options)
      end
      alias_method(:tag_without_attribute_locking, :tag)
      alias_method(:tag, :tag_with_attribute_locking)
      
      def content_tag_with_attribute_locking(name, content_or_options_with_block = nil, options = nil, &block)
        options = (options || {}).update("disabled" => attribute_locked?)
        content_tag_without_attribute_locking(name, content_or_options_with_block, options, &block)
      end
      alias_method(:content_tag_without_attribute_locking, :content_tag)
      alias_method(:content_tag, :content_tag_with_attribute_locking)
      
    private
      
      def date_or_time_select_with_attribute_locking(options)
        options[:disabled] = attribute_locked?
        date_or_time_select_without_attribute_locking(options)
      end
      alias_method(:date_or_time_select_without_attribute_locking, :date_or_time_select)
      alias_method(:date_or_time_select, :date_or_time_select_with_attribute_locking)
    
    end
  end
end
