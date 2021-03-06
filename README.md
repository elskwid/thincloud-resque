# Thincloud::Resque

## Description

Rails Engine to provide Resque support for Thincloud applications.

The Thincloud::Resque engine:

* Manages all of the Resque (and Redis) dependencies for your application
* Initializes the Redis connection and namespace for Resque
* Configures the Resque Front End (resque-web) to use HTTP Basic authentication
* Optionally configures `resque_mailer`
* Provides a Capistrano recipe to link resque-web assets during deployment


## Requirements

This gem requires Rails 3.2+ and has been tested on the following versions:

* 3.2

This gem has been tested against the following Ruby versions:

* 1.9.3


## Installation

Add this line to your application's Gemfile:

``` ruby
gem "thincloud-resque"
```

* Run `bundle`

Or install it yourself as:

```
$ gem install thincloud-resque
```

## Usage

### Configuration

Thincloud::Resque configuration options are available to customize the engine behavior. Available options and their default values:

```ruby
# Redis connection details
redis_url         = "unix:///tmp/redis.sock"
redis_namespace   = "resque:APP_NAME:RAILS_ENV"
redis_driver      = "ruby"  # make sure to include the gem for your driver

# Authenticaiton details used for the Resque Front End
web_username      = "thincloud-resque"
web_password      = "thincloud-resque"

# Environment(s) where Resque::Mailer should be enabled
mailer_environments = [:production]
```
#### Environment Variables

Several of the options will use environment variables when found.

```
redis_url    -> ENV["REDIS_URL"]
web_username -> ENV["RESQUE_WEB_USERNAME"]
web_password -> ENV["RESQUE_WEB_PASSWORD"]
```

#### Configuration Block

The `Thincloud::Resque` module accepts a `configure` block that takes the same options listed above. This block can be put into an initializer or inside of a `config/environments` file.

```ruby
Thincloud::Resque.configure do |config|
  config.redis_url       = "unix:///tmp/my_redis.sock"
  config.redis_namespace = "my_redis_namespace"
  config.redis_driver    = "hiredis"
  # ...
end
```

#### Rails Configuration

You can also access the configuration via the Rails configuration object. In fact, the engine uses the Rails config as storage when the block syntax is used. The `Thincloud::Resque::Configuration` object is made available under `config.thincloud.resque`. You can access this configuration in `config/application.rb` or in your `config/environments` files.

```ruby
# ...
config.thincloud.resque.redis_url       = "unix:///tmp/redis.sock"
config.thincloud.resque.redis_namespace = "my_config_namespace"
config.thincloud.resque.redis_driver    = "hiredis"
#...
```

_Note: Configuration values take precendence over environment variables._

#### Mailers

Resque::Mailer is enabled for environments included in the `mailer_environments` array. By default it will be enabled for all mailers in those environments. If you need to selectively enable it for specific mailers you can disable all environments:

```ruby
config.mailer_environments = []
```

and, for those mailers that need to background email, add the following line:

```ruby
include Resque::Mailer
```

#### Routes

Resque has a built-in Front End Sinatra (resque-web) server that provides access to monitor the Resque server's status. To allow access to the Front End through your app you need to mount the engine in `config/routes.rb`:

```ruby
mount Thincloud::Resque::Engine => "/resque"
```
=> `http://yourapp/resque`

Call this inside a namespace to create a nested route if needed:

```ruby
namespace :admin do
  mount Thincloud::Resque::Engine => "/resque"
end
```

=> `http://yourapp/admin/resque`

#### Capistrano

To make resque-web assets available to the released application, add the following line to your `deploy.rb` or `Capfile`:

```ruby
require "thincloud/resque/capistrano"
```

This adds a recipe called `thincloud:resque:link_assets` that will run after `deploy:update_code`. The recipe links the web assets from the Resque gem directory into your application's public directory.

#### Workers

You'll need Resque workers in order to have any jobs processed. We use `foreman` in our deployments to manage these. Simply add the following line to your `Procfile`:

```
worker: bundle exec rake environment resque:work RAILS_ENV=$RAILS_ENV QUEUE=*
```

_This assumes you're running bundler and that you need the environment loaded for these workers. Modify to suit your needs._

## Contributing

1. [Fork it](https://github.com/newleaders/thincloud-resque/fork_select)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. [Create a Pull Request](https://github.com/newleaders/thincloud-resque/pull/new)


## License

* Freely distributable and licensed under the [MIT license](http://newleaders.mit-license.org/2012/license.html).
* Copyright (c) 2012 New Leaders ([opensource@newleaders.com](opensource@newleaders.com))
* [https://newleaders.com](https://newleaders.com)

