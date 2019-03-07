# Avatax
[![CircleCI](https://circleci.com/gh/skukx/avatax.svg?style=shield)](https://circleci.com/gh/skukx/avatax)

This gem is a work in progress for providing a ruby client for Avatax REST api v2.
See: http://developer.avalara.com/avatax/api-reference/tax/v2/

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'avatax-ruby', git: 'git@github.com:skukx/avatax.git', require: 'avatax'
```

Or

```ruby
gem 'avatax-ruby', require: 'avatax'
```

And then execute:

    $ bundle

## Usage

### Setting Up the client
```ruby
client = Avatax::Client.new(
    username: 'avatax_user',
    password: 'avatax_password',
    env: :sandbox
)
```
The `env` can be set to `:sandbox` or `:production`.

### Estimating Taxes
```ruby
##
# Estimate by address
# @see http://developer.avalara.com/avatax/api-reference/tax/v2/TaxRates/#ApiV2TaxratesByaddressGet
#
params = {
    line1: '350 State St.',
    city: 'Salt Lake City',
    region: 'CA',
    postalCode: '84111',
    country: 'US'
}
resp = client.tax_rates.get(:by_address, params)

##
# Estimate by postal code
# @see http://developer.avalara.com/avatax/api-reference/tax/v2/TaxRates/#ApiV2TaxratesBypostalcodeGet
#
params = { country: 'US', postalCode: '84111' }
resp = client.tax_rates.get(:by_postal_code, params)

resp.success? # => true
```

### Transactions

#### Get all transactions within a company.
```ruby
client.transactions.all('my_company')
```

#### Find a transaction by code
```ruby
client.transactions.find_by_code('my_company', 'transaction_code')
```

#### Find a transaction by avatax id.
```ruby
client.transactions.find_by_id('my_company', '123')
```

#### Adjust an existing transaction.
```ruby
params = {
  adjustmentReason: 8,
  adjustmentDescription: 'New line item.',
  newTransaction: { ... }
}

client.transactions.adjust('my_company', 'my_code', params)
```

#### Change a transaction code
```ruby
params = { newCode: 'my_new_code' }
client.transactions.change_code('my_company', 'my_code', params)
```

#### Commit a transaction
By default, if not present, the post request will contain the body `{ commit: true }`

```ruby
client.transactions.commit('my_company', 'my_code')
```

#### Settle a transaction
This call can perform multiple actions on a transaction. See [avatax docs](https://developer.avalara.com/avatax/api-reference/tax/v2/Transactions/#SettleTransaction) for more information.
```ruby
params = { ... }
client.transactions.settle('my_company', 'my_code', params)
```

#### Void a transaction.
```ruby
client.transactions.void('my_company', 'my_code')
```

#### Create a transaction
```ruby
params = {
  code: 'my_code',
  type: 'SalesInvoice',
  companyCode: 'my_company',
  date: Date.current.to_s,
  customerCode: 1,
  discount: 0.00,
  addresses: {
    ShipTo: {
      line1: '50 Main street',
      city: 'Salt Lake City',
      region: 'UT',
      country: 'US',
      postalCode: '84144'
    }
  },
  lines: [
    {
      amount: 9.99,
      quantity: 1
    }
  ]
}

client.transactions.create(params)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/avatax.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
