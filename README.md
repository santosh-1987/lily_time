# LilyTime

There are two protocols available to talk to Lily: an RPC-style binary one based on Avro, which is used when you use the client Java API , and a REST-style API (HTTP+JSON).
Lily Time Provides user REST Interface to be used across applications to store date to Hbase.

## KnowledgeBase
The port on which the REST interface is listening is printed on repository startup, by default it is
12060:

Protocol [HTTP/1.1] listening on port 12060

For example, here is how you can access one of the records created earlier by the import:

## URL
 http://localhost:12060/repository/record/USER.Santosh_Mohanty

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

## Quick start

Kick the Functionality !

You can Start executing the following commands:

     @lily_scanner = LilyTime::Scanner.new({:url => "http://lily_url:12060/repository/scan",:recordType => "{my_demo.Article}Product"})

This would create a Scanner and with this scanner we will scan the records.
Or with rackup:

    @lily_scanner.scan_records

 To run the test suite completely, you can execute:
 
     LilyTime::Scanner.run_program
      => {:records=>[{"id"=>"UUID.a7166289-eb7a-4715-8c8e-3c997d752926", "version"=>2, "type"=>{"name"=>"ns1$product", "version"=>1}, "versionedType"=>{"name"=>"ns1$product", "version"=>1}, "fields"=>{"ns1$name"=>"Butter Masala", "ns1$price"=>4.25}, "namespaces"=>{"my.demo"=>"ns1"}}, {"id"=>"UUID.d6c5d9c9-15d6-4dd3-a4e9-b7ae293fc076", "version"=>1, "type"=>{"name"=>"ns1$product", "version"=>1}, "versionedType"=>{"name"=>"ns1$product", "version"=>1}, "fields"=>{"ns1$name"=>"Bread", "ns1$price"=>2.11}, "namespaces"=>{"my.demo"=>"ns1"}}], :scanner_deletion=>200, :error=>nil}


## What is Lily for ?

 *Lily manages `records` .
 *A record is a set `fields`.
 *Records adhere to a `record type` which specifies the `field types` that are allowed within the `record`. 
 *Field types define the kind of value that can be stored in the field (string, long, decimal, link, ...) and the `scope` of the field. 
 *The scope determines if the field is `versioned` or `not`. Versioned fields are `immutable`: upon each change of a versioned field a new version is created within the record.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/lily_time`. To experiment with that code, run `bin/console` for an interactive prompt.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/lily_time. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

