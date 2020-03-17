# frozen_string_literal: true

module ActiveResource
  class Base
    def save_changes(throw = false)
      # take copy of object
      copy = clone_with_nil

      yield

      # find changes
      changed_attributes = attributes.select { |key, value| !copy.attributes.key?(key) || (copy.attributes[key] != value) || (key == self.class.primary_key) }

      return unless changed_attributes.keys.any? { |key| key != self.class.primary_key }

      # create new object
      to_save = self.class.new(changed_attributes, true)

      # save
      throw ? to_save.save! : to_save.save
    end

    def save_changes!(&block)
      save_changes(true, &block)
    end

    def save_fields(fields, throw = false)
      to_save = clone_selected_fields(self, fields)

      throw ? to_save.save! : to_save.save
    end

    def save_fields!(fields)
      save_fields(fields, true)
    end

    def clone_with_nil
      # Clone all attributes except the pk and any nested ARes
      cloned = Hash[attributes.reject { |k, v| k == self.class.primary_key || v.is_a?(ActiveResource::Base) }.map { |k, v| [k, v.clone] }]
      # Form the new resource - bypass initialize of resource with 'new' as that will call 'load' which
      # attempts to convert hashes into member objects and arrays into collections of objects. We want
      # the raw objects to be cloned so we bypass load by directly setting the attributes hash.
      resource = self.class.new({})
      resource.prefix_options = prefix_options
      resource.send :instance_variable_set, '@attributes', cloned
      resource
    end

    def clone_selected_fields(model, fields)
      fields = fields.is_a?(Array) ? fields : fields.to_s.split(',').map(&:strip)

      # find fields
      changed_attributes = HashWithIndifferentAccess.new
      changed_attributes[model.class.primary_key] = model.attributes[model.class.primary_key]
      fields.each do |key|
        if key.include?(':')
          clone_sub_fields(model, key, changed_attributes)
        elsif fields.include?(key)
          changed_attributes[key] = model.attributes[key]
        end
      end

      # create new object
      self.class.new(changed_attributes, true)
    end

    private

    def clone_sub_fields(model, key, changed_attributes)
      sub_fields = key.split(':')
      sub_key = sub_fields.first
      values = model.attributes[sub_key]
      sub_fields = sub_fields.drop(1)
      changed_attributes[sub_key] = values.map { |value| clone_selected_fields(value, sub_fields) }
    end
  end
end
