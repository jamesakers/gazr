# Gazr

## Summary
Gazr is a development tool that's purpose is to continue on where Martin Aumont's watchr left off at Ruby 1.9.2. It currently is only slightly modified to work with `>=` Ruby 1.9.3.

* For use with `<=` Ruby 1.9.2 just use [watchr][1]: `gem install watchr` 

## Installation

Add this line to your application's Gemfile:

    gem 'gazr'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gazr

  If you're on Linux/BSD and have the [rev][4] gem installed, Gazr will detect
it and use it automatically. This will make Gazr evented.

    gem install rev

You can get the same evented behaviour on OS X by installing
[ruby-fsevent][10].

    gem install ruby-fsevent

## Usage

On the command line,

    $ gazr path/to/script.file

will monitor files in the current directory tree, and react to events on those
files in accordance with the script.

## Scripts

The script contains a set of simple rules that map observed files to an action.
Its DSL is a single method: `watch(pattern, &action)`

    watch( 'a regexp pattern matching paths to observe' )  {|match_data_object| command_to_run }

So for example,

    watch( 'test/test_.*\.rb' )  {|md| system("ruby #{md[0]}") }

will match any test file and run it whenever it is saved.

## Todos
* add default check for `~/.gazrrc` or `.gazrrc`
* add the ablility to have more then one file
    * have a global file that could apply to all project and a local for a specific project (Remains Flexible)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[1]:https://github.com/mynyml/watchr
[4]:  http://github.com/tarcieri/rev/
[10]: http://github.com/sandro/ruby-fsevent

