<p align="center">
  <img src="images/logo.png" alt="Cakemail Next-gen" />
</p>

# Cakemail Next-gen Ruby wrapper

<span>[![Gem Version](https://img.shields.io/gem/v/cakemail-next-gen.svg?label=cakemail-next-gen&colorA=D30001&colorB=DF3B3C)](https://rubygems.org/gems/cakemail-next-gen)</span> <span>
[![ruby](https://img.shields.io/badge/ruby-2.6+-ruby.svg?colorA=D30001&colorB=DF3B3C)](https://github.com/andrewdsilva/cakemail-ruby)</span> <span>
![Rubocop Status](https://img.shields.io/badge/rubocop-passing-rubocop.svg?colorA=1f7a1f&colorB=2aa22a)</span> <span>
[![MIT license](https://img.shields.io/badge/license-MIT-mit.svg?colorA=1f7a1f&colorB=2aa22a)](http://opensource.org/licenses/MIT)</span> <span>
![Downloads](https://img.shields.io/gem/dt/cakemail-next-gen.svg?colorA=004d99&colorB=0073e6)</span>

This library allows you to quickly and easily use the Cakemail Next-gen API via Ruby.

This gem is designed to be community-driven, with the aim of prioritizing the needs and preferences of its users. Your active involvement is crucial in shaping the future development of this project. You can contribute by creating issues and pull requests, as well as engaging with existing ones through upvoting or commenting.

If you need help using Cakemail, please check the Cakemail Support Help Center at https://www.cakemail.com/contact-us.

## Status 🚧

This gem is under construction. Stay tuned for exciting updates as I continue to shape it.

## Installation

To install the gem add it into a Gemfile (Bundler):

```ruby
gem "cakemail-next-gen"
```

And then execute:

```
bundle install
```

## API key

You need to set your Cakemail API credentials using environment variables.

```ruby
# .env
CAKEMAIL_API_KEY="..."
CAKEMAIL_USERNAME="..."
CAKEMAIL_PASSWORD="..."
```

If you wish to generate a new token, you will need the environment variables `CAKEMAIL_USERNAME` and `CAKEMAIL_PASSWORD`.

If you already have a token, you will only need: `CAKEMAIL_API_KEY`.

### Generating a Token

To generate a token, follow these steps:

1. Set the `CAKEMAIL_USERNAME` and `CAKEMAIL_PASSWORD` environment variables using a `.env` file.
2. Use the `Cakemail::Token.create` method provided by the gem to generate a token. Here's an example of how to use it :

```ruby
token = Cakemail::Token.create

pp "Access token created is #{token.access_token}"
```

## Usage

Cakemail-Ruby was designed with usability as its primary goal, so that you can forget the API and intuitively interact with your lists, contacts, campaigns and so on.

## Lists

Here are some basic usage examples for managing lists:

1. Fetching all lists:
```ruby
lists = Cakemail::List.all
lists.each do |list|
  puts "List ID: #{list.id}"
  puts "List Name: #{list.name}"
  # Additional list attributes can be accessed here
end
```

2. Creating a new list:
```ruby
new_list = Cakemail::List.create(name: "New List")
puts "Created List ID: #{new_list.id}"
puts "Created List Name: #{new_list.name}"
```

3. Updating an existing list:
```ruby
list = Cakemail::List.find(list_id)
list.update(name: "New name")
puts "Updated List Name: #{list.name}"
```

4. Deleting a list:
```ruby
list = Cakemail::List.find(list_id)
list.destroy
puts "List deleted successfully."
```

5. Archiving or unarchiving a list:
```ruby
list = Cakemail::List.find(list_id)
list.archive
# List is archived
list.unarchive
# List is unarchived
```

## Handling large data sets

The `find_in_batches` method, similar to its counterpart in ActiveRecord, allows you to retrieve records from a collection in batches. This is useful when dealing with large datasets, as it helps overcome API limitations by retrieving data in batches of 50, rather than loading the entire collection into memory at once.

Here's an example of how to use `find_in_batches` in the Cakemail Ruby Gem:

```ruby
Cakemail::List.find_in_batches do |list|
  puts list
end
```
