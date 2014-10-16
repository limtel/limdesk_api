# LimdeskApi

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
                                    
# reported_by can be mail, phone, other, chat
# client_id => -1 means "new anonymous clinet"
                                    
ticket2.ok?
true
ticket2.title
"a ticket"
							
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
                                    adress: "Plain Street 149 85-058 Warsaw"
client.ok?
true

client.delete!
true

client2 = LimdeskApi::Client.get(55)
client2.contacts.first

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
