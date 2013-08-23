module ActiveResource
  class Base
    def save_changes(throw = false, &block)
      # take copy of object
      copy = self.clone_with_nil

      yield

      #find changes
      changed_attributes = attributes.select{|key, value| !copy.attributes.has_key?(key) or copy.attributes[key] != value or key == self.class.primary_key }

      #create new object
      to_save = self.class.new(changed_attributes, true)

      #save
      throw ? to_save.save! : to_save.save
    end

    def save_changes!(&block)
      save_changes(true, &block)
    end

    def save_fields(fields, throw = false)
      fields = fields.to_s.split(',').map(&:strip)

      #find fields
      changed_attributes = attributes.select{|key, _| fields.include?(key) or key == self.class.primary_key }

      #create new object
      to_save = self.class.new(changed_attributes, true)

      #save
      throw ? to_save.save! : to_save.save
    end

    def save_fields!(fields)
      save_fields(fields, true)
    end

    def clone_with_nil
      # Clone all attributes except the pk and any nested ARes
      cloned = Hash[attributes.reject {|k,v| k == self.class.primary_key || v.is_a?(ActiveResource::Base)}.map { |k, v| [k, [NilClass, TrueClass, FalseClass, Fixnum].include?(v.class) ? v : v.clone] }]
      # Form the new resource - bypass initialize of resource with 'new' as that will call 'load' which
      # attempts to convert hashes into member objects and arrays into collections of objects. We want
      # the raw objects to be cloned so we bypass load by directly setting the attributes hash.
      resource = self.class.new({})
      resource.prefix_options = self.prefix_options
      resource.send :instance_variable_set, '@attributes', cloned
      resource
    end
  end
end