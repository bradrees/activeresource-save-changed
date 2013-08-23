# Activeresource::SaveChanged

This gem is to limit the saving of changes to an Active Resource object to only the field that have changed.

## Installation

Add this line to your application's Gemfile:

    gem 'activeresource-save-changed'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activeresource-save-changed

## Usage

### Specify changed fields

Instead of calling `save` on your AR objects, call `save_fields('list,of,field,names')`. You can also call `save_fields!('list,of,field,names')` to raise errors on failure.

### Detect changes automatically

Wrap your changes in a block and the changes will be automatically detected and saved when the block is complete.

    my_obj.save_changes {

    my_obj.field1 = new_value
    my_obj.field2 = same_as_current_value

    }

Will result in the object being persisted with only `field1` being sent to the server.

There is also an equivalent `save_changes!` method.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
