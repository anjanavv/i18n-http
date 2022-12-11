require "httparty"

module I18n
  module Http
    class Request
      attr_accessor :locale

      def initialize(locale)
        @locale = locale
      end

      def call
        response = HTTParty.get(url, headers: default_headers)
        response.parsed_response if response.success?
      rescue StandardError => error
        return nil
      end

      private

      def url
        config.endpoint.gsub("{locale}", locale.to_s)
      end

      def config
        I18n::Http.config
      end

      def default_headers
        { 
          "Accept" => "application/json",
          "Content-Type" => "application/json"
        }
      end
    end
  end
end
