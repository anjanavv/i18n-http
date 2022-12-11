require "i18n/http/version"
require "i18n/http/custom"
require "i18n/http/configuration"
require "i18n/http/request"

module I18n
  module Http
    class Error < StandardError; end
    # Your code goes here...

    class << self
      attr_accessor :config

      def configure
        @config ||= Configuration.new
        yield(config)
      end
    end
  end
end
