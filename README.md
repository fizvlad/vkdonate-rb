# Vkdonate

This is small non-official gem which provides interface to interact with vkdonate.ru API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vkdonate'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vkdonate

## Usage

You can check documentation [here](https://www.rubydoc.info/gems/vkdonate/).

To interact with API you are to initialize client firstly:

```ruby
client = Vkdonate::Client("API KEY GOES HERE")
```

After that you can call method `Client#donates` which returnes array of `Donate` objects:

```ruby
donates = client.donates(count: 10, order: :asc)
Vkdonate::Donate === donates[0] # => true
puts donates
=begin
Output:
Donation #1219946 by @157230821 for 1RUR (at 2019-09-22T01:35:47+03:00)
Donation #1219943 by @157230821 for 1RUR (at 2019-09-22T01:34:59+03:00)
Donation #1219941 by @157230821 for 1RUR (at 2019-09-22T01:33:37+03:00)
=end
```
