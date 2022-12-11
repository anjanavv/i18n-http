require 'i18n'
require 'httparty'
require 'active_support/core_ext/hash/keys'

module I18n
  module Http
    module ::I18n
      class << self
        alias_method :original_translate, :translate
        alias_method :original_localize, :localize

        def translate(key, **options)
          return original_translate(key, **options) unless http_config.enabled

          val = get_value(locale, key, **options)
          if val.nil?
            result = I18n::MissingTranslation.new(locale, key, options)
            handle_exception((options[:throw] && :throw || options[:raise] && :raise), result, locale, key, options)
          else
            return val
          end
        end

        def get_value(locale, key, **options)
          translations = get_translations(locale)
          return original_translate(key, **options) if translations.nil?

          split_keys = I18n.normalize_keys(locale, key, options[:scope], options[:separator])
          translations.deep_symbolize_keys!
          val = translations.dig(*split_keys)

          if val.nil? && options[:fallback] && locale != default_locale
            val = get_value(default_locale, key, **options)
          end
          return val
        end

        def http_config
          I18n::Http.config
        end
  
        def get_translations(locale)
          I18n::Http::Request.new(locale).call
        end

        alias_method :t, :translate
        alias_method :l, :localize
      end
    end
  end
end