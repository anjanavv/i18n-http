# I18n::Http

This gem monkey patches the I18n module to force fetching translation files via HTTP rather than just relying on local translation files. It should be possible to fall back to local translation files in case of any network issues

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'i18n-http'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install i18n-http

## Usage

Must ensure is a api response is as per i18n-ruby standards

Consider the following hypothetical locale files:
```yml
# en.yml
en:
    hello: "Hello world"
# en api reponse
en:
    hi: "Hi"
    hello: "Hello"

# de response
es:
    hello: "Hallo"
```

Calls to the new translation and would return the following:

```ruby
# Assume that I18n.default_locale = :en
# I18n::Http.config.enabled = false
I18n.t('hello')
# => "Hello world"
# I18n::Http.config.enabled = true
I18n.t('hello')
# => "Hello"
# Assume that I18n.locale = :de
I18n.t('hello')
# => "Hallo"
I18n.t('hi')
# => "Hi"
```

## Configuration
Simply add the following line to initializer `config/initializers/i18n_http_config.rb` file:

```ruby
# config/initializers/i18n_http_config.rb
I18n::Http.configure do
    # ... previous config
    config.enabled = true # will call original translation if set to false
    config.endpoint = "https://api.host.com/path/to/api/{locale}" # will take the current locale
end
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the I18n::Http project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/i18n-http/blob/master/CODE_OF_CONDUCT.md).
