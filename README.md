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
lists = Cakemail::List.list
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
list.delete
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

## Contacts

Here are some common use cases for managing contacts:

1. Retrieve all contacts in a list

To retrieve all contacts in a given list, you can use the `list` method of the `Cakemail::Contact` class. Make sure to specify the parent list when calling the method:

```ruby
# Get lists
lists = Cakemail::List.list

# Retrieve all contacts in a list
contacts = Cakemail::Contact.list(parent: lists.first)

contacts.each do |contact|
  puts "Email: #{contact.email}"
  puts "Status: #{contact.status}"
  puts "Subscription Date: #{Time.at(contact.subscribed_on)}"
  puts "---"
end

# Or directly from a list object
lists.first.contacts
```

2. Create a new contact

To create a new contact in a specific list, use the `create` method of the `Cakemail::Contact` class. Provide the necessary information, such as the email address, as a parameter hash:

```ruby
# Create a new contact
params = {
  email: "nathan.lopez042@gmail.com"
}

new_contact = Cakemail::Contact.create(params, parent: list)

puts "Contact created successfully."
puts "Email: #{new_contact.email}"
puts "Status: #{new_contact.status}"

# Or create from list

new_contact = list.create_contact(params)
puts "Contact created successfully."
```

3. Updating an existing contact:
```ruby
list = Cakemail::List.find(list_id)
contact = list.contacts.last

contact.update(email: "new_mail@gmail.com")
puts "Updated contact email: #{contact.email}"
```

4. Deleting a contact:
```ruby
list = Cakemail::List.find(list_id)
contact = list.contacts.last

contact.delete
puts "Contact deleted successfully."
```

5. Unsubscribe a contact:
```ruby
list = Cakemail::List.find(list_id)
contact = list.contacts.last

contact.unsubscribe
puts "Contact unsubscribed successfully."
```

## Custom attributes

Cakemail allows you to define custom attributes for your contacts. Here's how you can work with custom attributes:

1. Get list of custom attributes from a list object:

```ruby
attributes = @list.custom_attributes

attributes.each do |attribute|
  puts "Attribute Name: #{attribute.name}"
  puts "Attribute Type: #{attribute.type}"
  # Additional attribute details can be accessed here
end
```

2. Create a contact with custom attributes:

```ruby
attribute = @list.custom_attributes.first

params = {
  email: "nathan.lopez042@gmail.com",
  custom_attributes: [
    {
      name: attribute.name,
      value: "Nathan"
    }
  ]
}

contact = @list.create_contact(params)

puts "Contact created successfully."
puts "Email: #{contact.email}"
puts "Status: #{contact.status}"
puts "Custom Attribute: #{contact.custom_attributes.first['name']}: #{contact.custom_attributes.first['value']}"
```

You can create custom attributes on a list by using the `create` method of the `Cakemail::CustomAttributes` class. To do so, you need to provide the necessary information such as the name and type of the custom attribute. Here's an example code to create a text-type custom attribute with the name "firstname" on a given list:

```ruby
params = { name: "firstname", type: "text" }

Cakemail::CustomAttributes.create(params, parent: @list)
```
