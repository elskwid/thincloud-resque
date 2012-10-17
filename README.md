# Thincloud::Resque

## Description

Rails Engine to provide Resque support for Thincloud applications.

The Thincloud::Resque engine:

* Manages all of the Resque (and Redis) dependencies for your application
* Initializes the Redis connection and namespace for Resque
* Configures the Resque Front End to use HTTP Basic authentication at `/admin/resque`
* Optionally configures `resque_mailer`
* Provides a generator to add a Capistrano recipe and a Procfile entry

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

  # Option to configure Resque::Mailer
  mailer            = true  # configures Resque::Mailer
  mailer_excluded_environments = []
```
#### Environment Variables

Several of the options will use environment variables when found.

```
  redis_url    -> ENV["REDIS_URL"]
  web_username -> ENV["RESQUE_WEB_USERNAME"]
  web_password -> ENV["RESQUE_WEB_PASSWORD"]
```

#### Configuration Block

The `Thincloud::Resque` module accepts a `configure` block that accepts the same options listed above. This block can be put into an initializer or inside of a `config/environments` file.

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

### Generator

The generator will:

* Add a Capistrano recipe to make Resque web assets available to the released application. The recipe is added if both `Capfile` and `lib/recipes` are found.

* Add a `worker` entry to the Procfile if found.


Invoke the generator:

```
$ rails generate thincloud:resque
```

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

