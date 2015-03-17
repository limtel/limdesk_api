# LimdeskApi

[![Code Climate](https://codeclimate.com/github/limtel/limdesk_api/badges/gpa.svg)](https://codeclimate.com/github/limtel/limdesk_api)

## Installation

Add this line to your application's Gemfile:

    gem 'limdesk_api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install limdesk_api

## Usage

This gem will allow you to interact with Limdesk API. [Limdesk.com](http://limdesk.com) is a lightweight, multichannel customer support solution.

API is available to free and premium users. You can generate your APIKEY in Settings/Integration/API section.

This gem wrappes Limdesk API into OpenStruct (RecursiveOpenStruct) objects. For more information about API check the [official docs](http://help.limdesk.com/en/category/458/API_documentation). Current API covers basic, most common actions. More advanced version is currenty under development.

#### Connecting to API

```ruby
LimdeskApi.configure do |lim|
  lim.key = '<YOUR API KEY>'
  lim.version = 1
end
```

#### Tickets

```ruby

tickets = LimdeskApi::Ticket.all

tickets.count
63

tickets.first.title
"Hello World"

ticket = LimdeskApi::Ticket.get(44)

ticket.title
"Hello"

ticket.client.name
"John Smith"

ticket.answer content: 'this is a private comment', answer_type: :priv
ticket.answer content: 'dear customer, it is solved', answer_type: :pub

ticket.close content: 'its solved', type: :resolved
ticket.reopen
ticket.close content: 'spam', type: :rejected

ticket2 = LimdeskApi::Ticket.create :title => "problem",
                                    :content => "clients probem",
                                    :reported_by => :mail,
                                    :client_id => -1

# reported_by can be :mail, :phone, :other, :chat
# client_id => -1 means "new anonymous clinet"

ticket2.title
"sample ticket 2"

```

#### Activities

```ruby

acts = LimdeskApi::Activity.all

act = LimdeskApi::Activity.create content: "client has logged into website",
                                  client_id: 55
```

#### Clients


```ruby

cls = LimdeskApi::Client.all

cls.first.name
"John Smith"

client = LimdeskApi::Client.create  name: "John Smith",
                                    nippesel: "15012406496",
                                    phone: "223111789",
                                    email: "email@example.com",
                                    address: "Plain Street 149 85-058 Warsaw"
client.delete!
true

client2 = LimdeskApi::Client.get(55)
client2.contacts.first

client2.update name: "John Smith 2",
               nippesel: "123",
               phone: "11111",
               email: "emailnew@example.com",
               address: "Plain Street 149 85-058 Warsaw"
true

client3 = LimdeskApi::Client.get_by_email('adam@example.com')
client4 = LimdeskApi::Client.get_by_phone('+48897228989')
client4 = LimdeskApi::Client.get_by_outside_client_id('1234')
client5 = LimdeskApi::Client.get_by_nippesel('7393792360')
```

#### Sales

```ruby

sales=LimdeskApi::Sale.all

sale = sales.first

sale.name
"Hosting service 1yr"

sale.delete!
true

sale2 = LimdeskApi::Sale.create  client_id: 65464,
                                 name: "Shoes",
                                 price: 99.99,
                                 amount: 1,
                                 sold: "2014-10-20 20:00:00"
                                 create_ticket: true

sale2.client.name
"John Smith"

```

#### Contact Persons

```ruby

cp=LimdeskApi::Contactperson.create client_id: 338425,
                                    name: "Mr Smith",
                                    email: "ms@example.com",
                                    phone: "123456789"

cp.update email: "ms1@example.com"

cp.refresh!

cp.delete!
```

## TODO

* tests
* lazy loading

## Contributing

1. Fork it ( https://github.com/limtel/limdesk/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
