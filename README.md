# Buildkit

Ruby toolkit for the Buildkite API.

[![Build Status](https://secure.travis-ci.org/Shopify/buildkit.png)](http://travis-ci.org/Shopify/buildkit)
[![Gem Version](https://badge.fury.io/rb/buildkit.png)](http://badge.fury.io/rb/buildkit)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'buildkit'
```

And then execute:

    $ bundle

## Usage

`Buildkit` follow the same patterns than [`Octokit`](https://github.com/octokit/octokit.rb), if you are familiar with it you should feel right at home.

```ruby
client = Buildkit.new(token: 't0k3n')
organization = client.organization('my-great-org')
agents = organization.rels[:agents].get.data
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/shopify/buildkit/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
