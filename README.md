# LilyTime

There are two protocols available to talk to Lily: an RPC-style binary one based on Avro, which is used when you use the client Java API , and a REST-style API (HTTP+JSON).
Lily Time Provides user REST Interface to be used across applications to store date to Hbase.

The port on which the REST interface is listening is printed on repository startup, by default it is
12060:
Protocol [HTTP/1.1] listening on port 12060
For example, here is how you can access one of the records created earlier by the import:
http://localhost:12060/repository/record/USER.Santosh__Mohanty

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/lily_time`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
 'Please ensure that you have a running lily server with HBase to make this Gem Work !'
```


```ruby
gem 'lily_time'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install lily_time

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/lily_time. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

